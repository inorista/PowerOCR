import 'dart:io';
import 'package:flutter/material.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/bounding_box_painter.dart';
import 'package:powerocr/l10n/app_localizations.dart';

/// Widget hiển thị bounding boxes overlay lên ảnh document
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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base image
        GestureDetector(
          onTap: widget.onImageTap,
          child: Image.file(File(widget.imagePath), fit: BoxFit.contain),
        ),

        // Bounding boxes overlay
        if (_showBoundingBoxes && widget.boundingBoxes.isNotEmpty)
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onImageTap,
              child: CustomPaint(
                painter: BoundingBoxPainter(
                  boundingBoxes: widget.boundingBoxes,
                  imageWidth: widget.imageWidth,
                  imageHeight: widget.imageHeight,
                  strokeColor: Colors.cyan,
                  strokeWidth: 2.0,
                  fillColor: const Color.fromARGB(20, 0, 255, 255),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

        // Toggle button
        if (widget.boundingBoxes.isNotEmpty)
          Positioned(
            bottom: 16,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() => _showBoundingBoxes = !_showBoundingBoxes);
                },
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
                        _showBoundingBoxes ? l10n.scanResultHideBoxes : l10n.scanResultShowBoxes,
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
  }
}
