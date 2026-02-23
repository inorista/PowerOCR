import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScanBeamPainter extends CustomPainter {
  static const kBeamHeight = 80.0;
  final double progress;

  ScanBeamPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF00D4FF).withValues(alpha: 0.0),
          const Color(0xFF00D4FF).withValues(alpha: 0.12),
          const Color(0xFF00D4FF).withValues(alpha: 0.45),
          const Color(0xFF00AAFF).withValues(alpha: 0.65),
          const Color(0xFF00D4FF).withValues(alpha: 0.45),
          const Color(0xFF00D4FF).withValues(alpha: 0.12),
          const Color(0xFF00D4FF).withValues(alpha: 0.0),
          Colors.transparent,
        ],
        stops: const [0.0, 0.1, 0.3, 0.44, 0.5, 0.56, 0.7, 0.9, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), beamPaint);

    final linePaint = Paint()
      ..color = const Color(0xFFAAEEFF)
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      linePaint,
    );

    final glowPaint = Paint()
      ..color = const Color(0xFF00D4FF).withValues(alpha: 0.6)
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      glowPaint,
    );

    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final rng = math.Random(7);
    for (int i = 0; i < 5; i++) {
      final x = size.width * rng.nextDouble();
      canvas.drawCircle(Offset(x, size.height * 0.5), 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(ScanBeamPainter old) => old.progress != progress;
}
