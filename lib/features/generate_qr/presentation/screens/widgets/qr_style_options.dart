import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ColorOption {
  final Color color;
  final String label;

  const ColorOption(this.color, this.label);
}

const List<ColorOption> defaultColors = [
  ColorOption(Colors.black, 'Khói'),
  ColorOption(Color(0xFF2B3A67), 'Navy'),
  ColorOption(Color(0xFF5ABCAE), 'Mint'),
  ColorOption(Color(0xFFCBAACB), 'Lilac'),
  ColorOption(Color(0xFFE07A5F), 'Terra'),
];

class QrStyleOptions extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final QrEyeShape selectedEyeShape;
  final ValueChanged<QrEyeShape> onEyeShapeChanged;
  final QrDataModuleShape selectedDataShape;
  final ValueChanged<QrDataModuleShape> onDataShapeChanged;
  final bool isDarkBackground;
  final ValueChanged<bool> onBackgroundChanged;

  const QrStyleOptions({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    required this.selectedEyeShape,
    required this.onEyeShapeChanged,
    required this.selectedDataShape,
    required this.onDataShapeChanged,
    required this.isDarkBackground,
    required this.onBackgroundChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Màu sắc'),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: defaultColors.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final option = defaultColors[index];
              final isSelected = selectedColor == option.color;
              return GestureDetector(
                onTap: () => onColorChanged(option.color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: option.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: option.color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, color: Colors.white)
                      : null,
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 24),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(theme, 'Kiểu mắt (Eye)'),
                    const SizedBox(height: 12),
                    _buildToggle(
                      context: context,
                      theme: theme,
                      valueLeft: QrEyeShape.square,
                      valueRight: QrEyeShape.circle,
                      groupValue: selectedEyeShape,
                      onChanged: onEyeShapeChanged,
                      labelLeft: 'Vuông',
                      labelRight: 'Tròn',
                      iconLeft: Icons.square_outlined,
                      iconRight: Icons.circle_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(theme, 'Hoạ tiết (Data)'),
                    const SizedBox(height: 12),
                    _buildToggle(
                      context: context,
                      theme: theme,
                      valueLeft: QrDataModuleShape.square,
                      valueRight: QrDataModuleShape.circle,
                      groupValue: selectedDataShape,
                      onChanged: onDataShapeChanged,
                      labelLeft: 'Vuông',
                      labelRight: 'Tròn',
                      iconLeft: Icons.grid_on_rounded,
                      iconRight: Icons.blur_on_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(theme, 'Nền mã QR'),
              const SizedBox(height: 12),
              _buildToggle(
                context: context,
                theme: theme,
                valueLeft: false,
                valueRight: true,
                groupValue: isDarkBackground,
                onChanged: onBackgroundChanged,
                labelLeft: 'Nền trắng',
                labelRight: 'Nền tối',
                iconLeft: Icons.light_mode_outlined,
                iconRight: Icons.dark_mode_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildToggle<T>({
    required BuildContext context,
    required ThemeData theme,
    required T valueLeft,
    required T valueRight,
    required T groupValue,
    required ValueChanged<T> onChanged,
    required String labelLeft,
    required String labelRight,
    required IconData iconLeft,
    required IconData iconRight,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A26) : const Color(0xFFE5E6EE);
    
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              isSelected: groupValue == valueLeft,
              onTap: () => onChanged(valueLeft),
              label: labelLeft,
              icon: iconLeft,
              theme: theme,
            ),
          ),
          Expanded(
            child: _ToggleItem(
              isSelected: groupValue == valueRight,
              onTap: () => onChanged(valueRight),
              label: labelRight,
              icon: iconRight,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final ThemeData theme;

  const _ToggleItem({
    required this.isSelected,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
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
                color: isSelected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
