import 'package:flutter/material.dart';

class CornerBracketPainter extends CustomPainter {
  final double glow;
  final Color color;

  CornerBracketPainter({required this.glow, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: glow)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2 * glow);

    const len = 28.0;
    const r = 16.0;

    void drawCorner(Offset corner, bool flipX, bool flipY) {
      final sx = flipX ? -1.0 : 1.0;
      final sy = flipY ? -1.0 : 1.0;
      canvas.drawPath(
        Path()
          ..moveTo(corner.dx + sx * (len + r), corner.dy)
          ..lineTo(corner.dx + sx * r, corner.dy)
          ..arcToPoint(
            Offset(corner.dx, corner.dy + sy * r),
            radius: const Radius.circular(r),
            clockwise: flipX == flipY,
          )
          ..lineTo(corner.dx, corner.dy + sy * (len + r)),
        paint,
      );
    }

    drawCorner(Offset.zero, false, false);
    drawCorner(Offset(size.width, 0), true, false);
    drawCorner(Offset(0, size.height), false, true);
    drawCorner(Offset(size.width, size.height), true, true);
  }

  @override
  bool shouldRepaint(CornerBracketPainter old) => old.glow != glow;
}
