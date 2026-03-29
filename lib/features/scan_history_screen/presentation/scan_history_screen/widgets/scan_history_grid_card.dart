import 'dart:io';
import 'package:flutter/material.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/core/utils/extension.dart';

class ScanHistoryGridCard extends StatelessWidget {
  final ScanHistory item;
  final ThemeData theme;
  final bool isDark;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ScanHistoryGridCard({
    super.key,
    required this.item,
    required this.theme,
    required this.isDark,
    this.onTap,
    this.onLongPress,
  });

  String get _timeLabel {
    final diff = DateTime.now().difference(item.createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark
        ? const Color(0xFF2E2E3E).withValues(alpha: 0.80)
        : Colors.white.withValues(alpha: 0.88);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.05);
    final subtitleColor = theme.colorScheme.onSurface.withValues(
      alpha: isDark ? 0.45 : 0.40,
    );
    final isDocument = item.type == ScanHistoryType.document;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        radius: 18,
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.07),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildThumbnail(),
                      // Type badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _TypeBadge(
                          isDocument: isDocument,
                          isDark: isDark,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Info ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.text.isNotEmpty
                          ? item.text.plainText
                          : 'No text extracted',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: isDark ? 0.88 : 0.82,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 11,
                          color: subtitleColor,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            _timeLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: subtitleColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final hasImage =
        item.imagePath.isNotEmpty && File(item.imagePath).existsSync();

    if (hasImage) {
      return Image.file(
        File(item.imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, err, stack) =>
            _PlaceholderThumbnail(isDark: isDark, theme: theme),
      );
    }
    return _PlaceholderThumbnail(isDark: isDark, theme: theme);
  }
}

// ── Type Badge ─────────────────────────────────────────────────────────────
class _TypeBadge extends StatelessWidget {
  final bool isDocument;
  final bool isDark;
  final ThemeData theme;

  const _TypeBadge({
    required this.isDocument,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.55)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDocument ? Icons.description_rounded : Icons.qr_code_rounded,
            size: 10,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 3),
          Text(
            isDocument ? 'Doc' : 'QR',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}

// ── Placeholder Thumbnail ──────────────────────────────────────────────────
class _PlaceholderThumbnail extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _PlaceholderThumbnail({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : theme.colorScheme.primary.withValues(alpha: 0.06),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 36,
          color: theme.colorScheme.primary.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
