import 'dart:io';
import 'package:flutter/material.dart';
import 'package:powerocr/core/utils/extension.dart';
import 'package:powerocr/features/home/domain/entities/scan_history.dart';
import 'package:powerocr/features/home/presentation/screens/widgets/history_thumbnail_place_holder.dart';

class HistoryItem extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final ScanHistory item;
  final VoidCallback? onTap;

  const HistoryItem({
    super.key,
    required this.theme,
    required this.isDark,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark
        ? const Color(0xFF2E2E3E).withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.85);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.05);
    final subtitleColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.5 : 0.45,
    );

    final now = DateTime.now();
    final diff = now.difference(item.createdAt);
    final String timeLabel;
    if (diff.inMinutes < 1) {
      timeLabel = 'Just now';
    } else if (diff.inHours < 1) {
      timeLabel = '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      timeLabel = '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      timeLabel = 'Yesterday';
    } else {
      timeLabel = '${diff.inDays}d ago';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () {},
          child: Ink(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child:
                          item.imagePath.isNotEmpty &&
                              File(item.imagePath).existsSync()
                          ? Image.file(
                              File(item.imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  HistoryThumbnailPlaceholder(
                                    isDark: isDark,
                                    theme: theme,
                                  ),
                            )
                          : HistoryThumbnailPlaceholder(
                              isDark: isDark,
                              theme: theme,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.text.isNotEmpty
                              ? item.text.plainText
                              : 'No text extracted',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: isDark ? 0.9 : 0.85,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: subtitleColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: subtitleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.text_fields_rounded,
                              size: 12,
                              color: subtitleColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${item.text.split(' ').where((w) => w.isNotEmpty).length} words',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: subtitleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
