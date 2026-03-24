import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final bool isDark;
  final ThemeData theme;
  final AnimationController controller;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
    required this.theme,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark
        ? const Color(0xFF2E2E3E).withValues(alpha: 0.85)
        : Colors.white.withValues(alpha: 0.9);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final displayed = (value * controller.value).round();
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon,
                  size: 18,
                  color: theme.colorScheme.primary.withValues(alpha: 0.8)),
              const SizedBox(height: 8),
              Text(
                '$displayed',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
