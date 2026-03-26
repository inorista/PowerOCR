import 'package:flutter/material.dart';
import 'package:powerocr/features/home/presentation/screens/widgets/quick_action.dart';

class QuickActionTile extends StatefulWidget {
  final QuickAction action;
  final bool isDark;
  final ThemeData theme;

  const QuickActionTile({
    super.key,
    required this.action,
    required this.isDark,
    required this.theme,
  });

  @override
  State<QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<QuickActionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _pressScale = Tween(
      begin: 1.0,
      end: 0.93,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.action;
    final isDark = widget.isDark;

    return AnimatedBuilder(
      animation: _pressCtrl,
      builder: (context, child) => GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          action.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: Transform.scale(
          scale: _pressScale.value,
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: action.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: action.gradient.first.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(action.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: widget.theme.colorScheme.onSurface.withValues(
                    alpha: isDark ? 0.75 : 0.65,
                  ),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
