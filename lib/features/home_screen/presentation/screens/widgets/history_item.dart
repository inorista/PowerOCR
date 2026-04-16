import 'dart:io';
import 'package:flutter/material.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/utils/extension.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/history_thumbnail_place_holder.dart';
import 'package:powerocr/l10n/app_localizations.dart';
class HistoryItem extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final ScanHistory item;
  final VoidCallback? onTap;
  /// When true, uses tighter padding suitable for the 2-col home grid on tablet.
  final bool isCompact;

  const HistoryItem({
    super.key,
    required this.theme,
    required this.isDark,
    required this.item,
    this.onTap,
    this.isCompact = false,
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
    final l10n = AppLocalizations.of(context)!;
    final String timeLabel;
    if (diff.inMinutes < 1) {
      timeLabel = l10n.timeJustNow;
    } else if (diff.inHours < 1) {
      timeLabel = l10n.timeMinutesAgo(diff.inMinutes);
    } else if (diff.inDays < 1) {
      timeLabel = l10n.timeHoursAgo(diff.inHours);
    } else if (diff.inDays == 1) {
      timeLabel = l10n.timeYesterday;
    } else {
      timeLabel = l10n.timeDaysAgo(diff.inDays);
    }

    return Padding(
      padding: isCompact
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(24, 0, 24, 10),
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
                      width: 64,
                      height: 64,
                      child:
                          item.imagePath.isNotEmpty &&
                              File(item.imagePath).existsSync()
                          ? Image.file(
                              File(item.imagePath),
                              fit: BoxFit.cover,
                              cacheHeight: 250,
                              cacheWidth: 200,
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
                              : l10n.historyNoTextExtracted,
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
                          crossAxisAlignment: .center,
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
                            Text(
                              " • ${item.type == ScanHistoryType.document ? l10n.historyTypeDocument : l10n.historyTypeQr}",
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
                            Expanded(
                              child: Text(
                                l10n.historyWordCount(item.text.split(' ').where((w) => w.isNotEmpty).length),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: subtitleColor,
                                  fontWeight: FontWeight.w500,
                                ),
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
