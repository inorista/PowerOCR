import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:powerocr/l10n/app_localizations.dart';

/// Overlay bounding boxes lên ảnh document.
///
/// Thay vì tự tính scale/offset, widget này dùng LayoutBuilder để tìm
/// kích thước thực của container, rồi tính chính xác vùng ảnh hiển thị
/// (BoxFit.contain) và map tọa độ từ image-space sang widget-space.
class BoundingBoxOverlay extends StatefulWidget {
  final String imagePath;
  final List<List<double>> boundingBoxes;
  final int imageWidth;
  final int imageHeight;
  final VoidCallback? onImageTap;

  const BoundingBoxOverlay({
    super.key,
    required this.imagePath,
    required this.boundingBoxes,
    required this.imageWidth,
    required this.imageHeight,
    this.onImageTap,
  });

  @override
  State<BoundingBoxOverlay> createState() => _BoundingBoxOverlayState();
}

class _BoundingBoxOverlayState extends State<BoundingBoxOverlay> {
  bool _showBoundingBoxes = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerW = constraints.maxWidth;
        final double containerH = constraints.maxHeight;

        // ── Compute where the image actually renders (BoxFit.contain) ────────
        // BoxFit.contain: scale to fit within the container, centered.
        double renderedW = 0;
        double renderedH = 0;
        double offsetX = 0;
        double offsetY = 0;

        if (widget.imageWidth > 0 && widget.imageHeight > 0) {
          final double scaleX = containerW / widget.imageWidth;
          final double scaleY = containerH / widget.imageHeight;
          final double scale = scaleX < scaleY ? scaleX : scaleY;

          renderedW = widget.imageWidth * scale;
          renderedH = widget.imageHeight * scale;
          offsetX = (containerW - renderedW) / 2;
          offsetY = (containerH - renderedH) / 2;
        }

        return Stack(
          children: [
            // ── Base image (BoxFit.contain) ──────────────────────────────────
            GestureDetector(
              onTap: widget.onImageTap,
              child: SizedBox.expand(
                child: Image.file(File(widget.imagePath), fit: BoxFit.contain),
              ),
            ),

            // ── Bounding boxes ───────────────────────────────────────────────
            if (_showBoundingBoxes &&
                widget.boundingBoxes.isNotEmpty &&
                renderedW > 0)
              Positioned(
                left: offsetX,
                top: offsetY,
                width: renderedW,
                height: renderedH,
                child: GestureDetector(
                  onTap: widget.onImageTap,
                  child: CustomPaint(
                    painter: _NormalizedBoxPainter(
                      boundingBoxes: widget.boundingBoxes,
                      imageWidth: widget.imageWidth.toDouble(),
                      imageHeight: widget.imageHeight.toDouble(),
                    ),
                  ),
                ),
              ),

            // ── Toggle button ────────────────────────────────────────────────
            if (widget.boundingBoxes.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(
                      () => _showBoundingBoxes = !_showBoundingBoxes,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _showBoundingBoxes
                            ? Colors.cyan.withValues(alpha: 0.8)
                            : Colors.grey.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showBoundingBoxes
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _showBoundingBoxes
                                ? l10n.scanResultHideBoxes
                                : l10n.scanResultShowBoxes,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Painter nhận bounding boxes đã ở image-space và vẽ chúng lên canvas
/// có kích thước chính xác bằng vùng ảnh (renderedW × renderedH).
/// Không cần tính scale/offset vì canvas đã được định vị chính xác bằng
/// Positioned widget ở trên.
class _NormalizedBoxPainter extends CustomPainter {
  final List<List<double>> boundingBoxes;
  final double imageWidth;
  final double imageHeight;

  const _NormalizedBoxPainter({
    required this.boundingBoxes,
    required this.imageWidth,
    required this.imageHeight,
  });

  // Curated palette — 12 visually distinct, high-contrast colors
  // evenly spaced across the hue wheel (HSL saturation 85%, lightness 58%)
  static const List<Color> _palette = [
    Color(0xFFFF6B6B), // Red
    Color(0xFFFF9F43), // Orange
    Color(0xFFFECA57), // Yellow
    Color(0xFF48DBFB), // Cyan
    Color(0xFF0ABDE3), // Sky
    Color(0xFF54A0FF), // Blue
    Color(0xFF5F27CD), // Violet
    Color(0xFFC44AFF), // Purple
    Color(0xFFFF6FB5), // Pink
    Color(0xFF1DD1A1), // Emerald
    Color(0xFF10AC84), // Green
    Color(0xFF00D2D3), // Teal
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (imageWidth <= 0 || imageHeight <= 0) return;

    final double scaleX = size.width / imageWidth;
    final double scaleY = size.height / imageHeight;

    for (int i = 0; i < boundingBoxes.length; i++) {
      final box = boundingBoxes[i];
      if (box.length < 4) continue;

      final color = _palette[i % _palette.length];

      final Paint stroke = Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final Paint fill = Paint()
        ..color = color.withValues(alpha: 0.08)
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTRB(
        box[0] * scaleX,
        box[1] * scaleY,
        box[2] * scaleX,
        box[3] * scaleY,
      );

      final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      canvas.drawRRect(rRect, fill);
      canvas.drawRRect(rRect, stroke);
    }
  }

  @override
  bool shouldRepaint(_NormalizedBoxPainter old) =>
      old.boundingBoxes != boundingBoxes ||
      old.imageWidth != imageWidth ||
      old.imageHeight != imageHeight;
}
