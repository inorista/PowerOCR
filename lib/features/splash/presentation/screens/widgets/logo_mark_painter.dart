import 'dart:math' as math;
import 'package:flutter/material.dart';

class LogoMarkPainter extends CustomPainter {
  final double progress;
  final double glow;
  LogoMarkPainter({required this.progress, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;

    final ringPaint = Paint()
      ..color = const Color(0xFF00D4FF).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * glow);
    canvas.drawCircle(Offset(cx, cy), r, ringPaint);

    final innerPaint = Paint()
      ..color = const Color(0xFF00AAFF).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(cx, cy), r * 0.65, innerPaint);

    final linePaint = Paint()
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    const lineCount = 6;
    for (int i = 0; i < lineCount; i++) {
      final t = i / (lineCount - 1);
      final lineY = cy - r * 0.7 + t * r * 1.4;

      final halfW = math.sqrt(math.max(0, r * r - math.pow(lineY - cy, 2)));
      if (halfW < 2) continue;

      final alpha = (0.3 + 0.4 * (1 - (t - 0.5).abs() * 2)) * progress;
      linePaint.color = Color.fromARGB((alpha * 255).toInt(), 0, 212, 255);
      canvas.drawLine(
          Offset(cx - halfW, lineY), Offset(cx + halfW, lineY), linePaint);
    }

    canvas.drawCircle(
        Offset(cx, cy),
        4,
        Paint()
          ..color = const Color(0xFF00D4FF)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * glow));
    canvas.drawCircle(Offset(cx, cy), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(LogoMarkPainter old) =>
      old.progress != progress || old.glow != glow;
}
