import 'package:flutter/material.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });
}
