import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlashButton extends StatelessWidget {
  final FlashMode mode;
  final VoidCallback onTap;

  const FlashButton({super.key, required this.mode, required this.onTap});

  IconData get _icon => switch (mode) {
        FlashMode.always => Icons.flash_on_rounded,
        FlashMode.off => Icons.flash_off_rounded,
        _ => Icons.flash_auto_rounded,
      };

  String get _label => switch (mode) {
        FlashMode.always => 'On',
        FlashMode.off => 'Off',
        _ => 'Auto',
      };

  Color get _iconColor => switch (mode) {
        FlashMode.off => Colors.white60,
        _ => const Color(0xFFFFD54F),
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 52,
            height: 44,
            decoration: BoxDecoration(
              color: mode == FlashMode.off
                  ? Colors.black.withValues(alpha: 0.4)
                  : const Color(0xFFFFD54F).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: mode == FlashMode.off
                    ? Colors.white.withValues(alpha: 0.12)
                    : const Color(0xFFFFD54F).withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    _icon,
                    key: ValueKey(mode),
                    color: _iconColor,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Text(
                    _label,
                    key: ValueKey(mode),
                    style: TextStyle(
                      color: _iconColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
