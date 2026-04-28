import 'package:flutter/material.dart';

/// Custom Painter để vẽ các bounding boxes xung quanh các đoạn văn
class BoundingBoxPainter extends CustomPainter {
  final List<List<double>> boundingBoxes;
  final int imageWidth;
  final int imageHeight;
  final double strokeWidth;
  final BoxFit fit;

  // Curated palette — 12 visually distinct, high-contrast colors
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

  BoundingBoxPainter({
    required this.boundingBoxes,
    required this.imageWidth,
    required this.imageHeight,
    this.strokeWidth = 2.0,
    this.fit = BoxFit.contain,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (imageWidth <= 0 || imageHeight <= 0) return;

    // Calculate scale and offset based on BoxFit
    final double scaleX = size.width / imageWidth;
    final double scaleY = size.height / imageHeight;

    double scale;
    if (fit == BoxFit.contain) {
      scale = scaleX < scaleY ? scaleX : scaleY;
    } else {
      scale = scaleX > scaleY ? scaleX : scaleY; // Default to cover
    }

    final double scaledImageWidth = imageWidth * scale;
    final double scaledImageHeight = imageHeight * scale;

    final double dx = (size.width - scaledImageWidth) / 2;
    final double dy = (size.height - scaledImageHeight) / 2;

    for (int i = 0; i < boundingBoxes.length; i++) {
      final box = boundingBoxes[i];
      // box format: [minX, minY, maxX, maxY]
      if (box.length >= 4) {
        final color = _palette[i % _palette.length];

        final paint = Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

        final fillPaint = Paint()
          ..color = color.withValues(alpha: 0.08)
          ..style = PaintingStyle.fill;

        final rect = Rect.fromLTRB(
          box[0] * scale + dx,
          box[1] * scale + dy,
          box[2] * scale + dx,
          box[3] * scale + dy,
        );

        final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
        // Vẽ fill trước
        canvas.drawRRect(rRect, fillPaint);
        // Vẽ border
        canvas.drawRRect(rRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return oldDelegate.boundingBoxes != boundingBoxes ||
        oldDelegate.imageWidth != imageWidth ||
        oldDelegate.imageHeight != imageHeight;
  }
}
