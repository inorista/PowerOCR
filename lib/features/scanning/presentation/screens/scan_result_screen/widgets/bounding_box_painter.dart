import 'package:flutter/material.dart';

/// Custom Painter để vẽ các bounding boxes xung quanh các đoạn văn
class BoundingBoxPainter extends CustomPainter {
  final List<List<double>> boundingBoxes;
  final int imageWidth;
  final int imageHeight;
  final Color strokeColor;
  final double strokeWidth;
  final Color fillColor;
  final BoxFit fit;

  BoundingBoxPainter({
    required this.boundingBoxes,
    required this.imageWidth,
    required this.imageHeight,
    this.strokeColor = Colors.cyan,
    this.strokeWidth = 2.0,
    this.fillColor = const Color.fromARGB(30, 0, 255, 255),
    this.fit = BoxFit.contain,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (imageWidth <= 0 || imageHeight <= 0) return;

    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

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

    for (final box in boundingBoxes) {
      // box format: [minX, minY, maxX, maxY]
      if (box.length >= 4) {
        final rect = Rect.fromLTRB(
          box[0] * scale + dx,
          box[1] * scale + dy,
          box[2] * scale + dx,
          box[3] * scale + dy,
        );

        // Vẽ fill trước
        canvas.drawRect(rect, fillPaint);

        // Vẽ border
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return oldDelegate.boundingBoxes != boundingBoxes ||
        oldDelegate.imageWidth != imageWidth ||
        oldDelegate.imageHeight != imageHeight ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.fillColor != fillColor;
  }
}
