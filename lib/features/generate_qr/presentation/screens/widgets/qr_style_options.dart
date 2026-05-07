import 'package:flutter/material.dart';

import 'package:powerocr/features/generate_qr/presentation/bloc/generate_qr_state.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class ColorOption {
  final Color color;
  final String labelKey;

  const ColorOption(this.color, this.labelKey);
}

const List<ColorOption> defaultColors = [
  ColorOption(Colors.black, 'Smoke'),
  ColorOption(Color(0xFF2B3A67), 'Navy'),
  ColorOption(Color(0xFF5ABCAE), 'Mint'),
  ColorOption(Color(0xFFCBAACB), 'Lilac'),
  ColorOption(Color(0xFFE07A5F), 'Terra'),
  ColorOption(Color(0xFF6C63FF), 'Iris'),
  ColorOption(Color(0xFF2D9CDB), 'Ocean'),
  ColorOption(Color(0xFFEB5757), 'Rose'),
];

class QrStyleOptions extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final QrEyeStyle selectedEyeStyle;
  final ValueChanged<QrEyeStyle> onEyeStyleChanged;
  final QrModuleStyle selectedModuleStyle;
  final ValueChanged<QrModuleStyle> onModuleStyleChanged;
  final bool isDarkBackground;
  final ValueChanged<bool> onBackgroundChanged;

  const QrStyleOptions({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    required this.selectedEyeStyle,
    required this.onEyeStyleChanged,
    required this.selectedModuleStyle,
    required this.onModuleStyleChanged,
    required this.isDarkBackground,
    required this.onBackgroundChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Color Section ──
        _SectionHeader(icon: Icons.palette_outlined, title: l10n.generateQrColor),
        const SizedBox(height: 12),
        _buildColorPicker(theme),
        const SizedBox(height: 28),

        // ── Eye Shape Section ──
        _SectionHeader(
          icon: Icons.visibility_outlined,
          title: l10n.generateQrEyeShape,
        ),
        const SizedBox(height: 12),
        _buildShapeSelector<QrEyeStyle>(
          context: context,
          theme: theme,
          isDark: isDark,
          values: QrEyeStyle.values,
          selected: selectedEyeStyle,
          onChanged: onEyeStyleChanged,
          labelBuilder: (v) => _eyeStyleLabel(v, l10n),
          iconBuilder: _eyeStyleIcon,
        ),
        const SizedBox(height: 28),

        // ── Pattern Section ──
        _SectionHeader(
          icon: Icons.grid_view_rounded,
          title: l10n.generateQrPattern,
        ),
        const SizedBox(height: 12),
        _buildShapeSelector<QrModuleStyle>(
          context: context,
          theme: theme,
          isDark: isDark,
          values: QrModuleStyle.values,
          selected: selectedModuleStyle,
          onChanged: onModuleStyleChanged,
          labelBuilder: (v) => _moduleStyleLabel(v, l10n),
          iconBuilder: _moduleStyleIcon,
        ),
        const SizedBox(height: 28),

        // ── Background Section ──
        _SectionHeader(
          icon: Icons.contrast_rounded,
          title: l10n.generateQrBackground,
        ),
        const SizedBox(height: 12),
        _buildBackgroundToggle(theme, isDark, l10n),
      ],
    );
  }

  // ── Color Picker ──────────────────────────────────────────────────────────
  Widget _buildColorPicker(ThemeData theme) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: defaultColors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final option = defaultColors[index];
          final isSelected = selectedColor == option.color;
          return GestureDetector(
            onTap: () => onColorChanged(option.color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: option.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: option.color.withValues(alpha: 0.45),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: option.color.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Shape Selector (reusable for eye & module) ────────────────────────────
  Widget _buildShapeSelector<T>({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required List<T> values,
    required T selected,
    required ValueChanged<T> onChanged,
    required String Function(T) labelBuilder,
    required IconData Function(T) iconBuilder,
  }) {
    return Row(
      children: values.map((value) {
        final isSelected = value == selected;
        final primary = theme.colorScheme.primary;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: value != values.last ? 10 : 0,
            ),
            child: GestureDetector(
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                height: 72,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary.withValues(alpha: isDark ? 0.2 : 0.08)
                      : isDark
                          ? const Color(0xFF1E1E2E)
                          : const Color(0xFFF3F4F8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? primary.withValues(alpha: 0.6)
                        : isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.04),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      iconBuilder(value),
                      size: 24,
                      color: isSelected
                          ? primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labelBuilder(value),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Background Toggle ─────────────────────────────────────────────────────
  Widget _buildBackgroundToggle(
      ThemeData theme, bool isDark, AppLocalizations l10n) {
    final bgColor = isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF3F4F8);
    final primary = theme.colorScheme.primary;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _ToggleChip(
              isSelected: !isDarkBackground,
              onTap: () => onBackgroundChanged(false),
              label: l10n.generateQrBgWhite,
              icon: Icons.light_mode_rounded,
              theme: theme,
              primary: primary,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _ToggleChip(
              isSelected: isDarkBackground,
              onTap: () => onBackgroundChanged(true),
              label: l10n.generateQrBgDark,
              icon: Icons.dark_mode_rounded,
              theme: theme,
              primary: primary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _eyeStyleLabel(QrEyeStyle style, AppLocalizations l10n) {
    switch (style) {
      case QrEyeStyle.square:
        return l10n.generateQrShapeSquare;
      case QrEyeStyle.dots:
        return l10n.generateQrShapeCircle;
      case QrEyeStyle.smooth:
        return l10n.generateQrShapeSmooth;
    }
  }

  IconData _eyeStyleIcon(QrEyeStyle style) {
    switch (style) {
      case QrEyeStyle.square:
        return Icons.crop_square_rounded;
      case QrEyeStyle.dots:
        return Icons.radio_button_unchecked_rounded;
      case QrEyeStyle.smooth:
        return Icons.rounded_corner_rounded;
    }
  }

  String _moduleStyleLabel(QrModuleStyle style, AppLocalizations l10n) {
    switch (style) {
      case QrModuleStyle.square:
        return l10n.generateQrShapeSquare;
      case QrModuleStyle.dots:
        return l10n.generateQrShapeCircle;
      case QrModuleStyle.smooth:
        return l10n.generateQrShapeSmooth;
    }
  }

  IconData _moduleStyleIcon(QrModuleStyle style) {
    switch (style) {
      case QrModuleStyle.square:
        return Icons.grid_on_rounded;
      case QrModuleStyle.dots:
        return Icons.blur_on_rounded;
      case QrModuleStyle.smooth:
        return Icons.waves_rounded;
    }
  }
}

// ── Section Header ──────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

// ── Toggle Chip ─────────────────────────────────────────────────────────────
class _ToggleChip extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final ThemeData theme;
  final Color primary;

  const _ToggleChip({
    required this.isSelected,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.theme,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
