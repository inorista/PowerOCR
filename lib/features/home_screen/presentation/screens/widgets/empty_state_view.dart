import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;

  const EmptyStateView({
    super.key,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark
        ? const Color(0xFF2E2E3E).withValues(alpha: 0.7)
        : Colors.white.withValues(alpha: 0.8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.document_scanner_outlined,
                size: 30,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No scans yet',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your scanned documents will appear here.\nTap Scan to get started!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
