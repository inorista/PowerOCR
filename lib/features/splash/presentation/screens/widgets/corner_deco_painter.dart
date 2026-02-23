import 'package:flutter/material.dart';

class CornerDecoPainter extends CustomPainter {
  final double glowIntensity;
  CornerDecoPainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB((180 * glowIntensity).toInt(), 0, 212, 255)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2 * glowIntensity);

    const margin = 24.0;
    const length = 32.0;

    canvas.drawPath(
        Path()
          ..moveTo(margin, margin + length)
          ..lineTo(margin, margin)
          ..lineTo(margin + length, margin),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(size.width - margin - length, margin)
          ..lineTo(size.width - margin, margin)
          ..lineTo(size.width - margin, margin + length),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(margin, size.height - margin - length)
          ..lineTo(margin, size.height - margin)
          ..lineTo(margin + length, size.height - margin),
        paint);

    canvas.drawPath(
        Path()
          ..moveTo(size.width - margin - length, size.height - margin)
          ..lineTo(size.width - margin, size.height - margin)
          ..lineTo(size.width - margin, size.height - margin - length),
        paint);

    final cy = size.height / 2 - 28;
    final cx = size.width / 2;
    final ringPaint = Paint()
      ..color = const Color(0xFF00D4FF).withValues(alpha: 0.15 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(cx, cy), 60, ringPaint);
    canvas.drawCircle(
        Offset(cx, cy),
        80,
        ringPaint
          ..color =
              const Color(0xFF00D4FF).withValues(alpha: 0.08 * glowIntensity));
  }

  @override
  bool shouldRepaint(CornerDecoPainter old) =>
      old.glowIntensity != glowIntensity;
}
