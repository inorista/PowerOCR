import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/core/theme/cubit/theme_cubit.dart';

class HomeHeader extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const HomeHeader({super.key, required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isDark
                        ? [const Color(0xFFCBCDEC), const Color(0xFF95E1D3)]
                        : [const Color(0xFF6B6FCC), const Color(0xFF55C7B5)],
                  ).createShader(bounds),
                  child: Text(
                    'PowerOCR',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          HeaderIconButton(
            isDark: isDark,
            icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            onTap: () {
              context.read<ThemeCubit>().setTheme(
                isDark ? ThemeMode.light : ThemeMode.dark,
              );
            },
            theme: theme,
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Chào buổi sáng ☀️';
    if (hour < 17) return 'Chào buổi chiều 🌤️';
    return 'Chào buổi tối 🌙';
  }
}

class HeaderIconButton extends StatefulWidget {
  final bool isDark;
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;

  const HeaderIconButton({
    super.key,
    required this.isDark,
    required this.icon,
    required this.onTap,
    required this.theme,
  });

  @override
  State<HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<HeaderIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Transform.scale(
          scale: _scale.value,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              widget.icon,
              color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
