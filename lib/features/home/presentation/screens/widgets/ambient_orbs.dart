import 'package:flutter/material.dart';
import 'package:powerocr/features/home/presentation/screens/widgets/orb_painter.dart';

class AmbientOrbs extends StatelessWidget {
  final double rotate;
  final bool isDark;
  final Color primary;
  final Size size;

  const AmbientOrbs({super.key, 
    required this.rotate,
    required this.isDark,
    required this.primary,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: OrbPainter(rotate: rotate, isDark: isDark, primary: primary),
    );
  }
}
