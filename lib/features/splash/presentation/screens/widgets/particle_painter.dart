import 'package:flutter/material.dart';
import 'package:powerocr/features/splash/presentation/screens/widgets/particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double beamY;
  final double progress;

  ParticlePainter(
      {required this.particles, required this.beamY, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final px = p.x * size.width;
      final py = p.y * size.height;

      final dy = ((py / size.height) - beamY).abs();
      final boost = (1.0 - (dy / 0.12).clamp(0.0, 1.0)) * 0.8 * progress;

      final paint = Paint()
        ..color = Color.fromARGB(
          ((p.opacity + boost) * 255).clamp(0, 255).toInt(),
          0,
          212,
          255,
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

      canvas.drawCircle(Offset(px, py), p.size + boost, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) =>
      old.beamY != beamY || old.progress != progress;
}
