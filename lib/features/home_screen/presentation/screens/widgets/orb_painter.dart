import 'dart:math' as math;
import 'package:flutter/material.dart';

class OrbPainter extends CustomPainter {
  final double rotate;
  final bool isDark;
  final Color primary;

  OrbPainter(
      {required this.rotate, required this.isDark, required this.primary});

  @override
  void paint(Canvas canvas, Size size) {
    final ox = size.width * 0.85 + math.cos(rotate) * 12;
    final oy = size.height * 0.08 + math.sin(rotate) * 8;
    _drawOrb(canvas, Offset(ox, oy), 130,
        primary.withValues(alpha: isDark ? 0.18 : 0.10));

    final ox2 = size.width * 0.05 + math.sin(rotate) * 10;
    final oy2 = size.height * 0.55 + math.cos(rotate) * 14;
    _drawOrb(canvas, Offset(ox2, oy2), 110,
        const Color(0xFF95E1D3).withValues(alpha: isDark ? 0.13 : 0.08));
  }

  void _drawOrb(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(colors: [color, Colors.transparent])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(OrbPainter old) =>
      old.rotate != rotate || old.isDark != isDark;
}
