import 'package:flutter/material.dart';

class ResultTextSection extends StatelessWidget {
  final String extractedText;
  final bool showAlignedFormat;
  final bool isDark;
  final double bottomPadding;
  final Animation<double> contentFade;

  const ResultTextSection({
    super.key,
    required this.extractedText,
    required this.showAlignedFormat,
    required this.isDark,
    required this.bottomPadding,
    required this.contentFade,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (extractedText.trim().isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: FadeTransition(
          opacity: contentFade,
          child: _buildEmptyText(theme),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: contentFade,
        child: Container(
          color: isDark ? const Color(0xFF1A1A26) : const Color(0xFFF2F3F8),
          padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 90),
          child: showAlignedFormat
              ? _buildAlignedTextView(theme)
              : _buildPureTextView(theme),
        ),
      ),
    );
  }

  Widget _buildEmptyText(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.text_fields_rounded,
          size: 48,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
        const SizedBox(height: 12),
        Text(
          'Không phát hiện văn bản',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Thử quét ảnh rõ hơn',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildPureTextView(ThemeData theme) {
    return SelectableText(
      extractedText,
      style: TextStyle(
        fontSize: 15,
        height: 1.7,
        letterSpacing: 0.1,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
      ),
    );
  }

  Widget _buildAlignedTextView(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SelectableText(
        extractedText,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 14,
          height: 1.65,
          letterSpacing: 0,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
        ),
      ),
    );
  }
}
