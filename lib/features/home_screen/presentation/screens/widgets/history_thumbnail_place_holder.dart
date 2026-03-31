import 'package:flutter/material.dart';

class HistoryThumbnailPlaceholder extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const HistoryThumbnailPlaceholder({
    super.key,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.image_outlined,
        size: 24,
        color: theme.colorScheme.primary.withValues(alpha: 0.45),
      ),
    );
  }
}
