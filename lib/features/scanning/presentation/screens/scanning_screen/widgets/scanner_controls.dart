import 'dart:ui';
import 'package:flutter/material.dart';

class ScannerControls extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCaptureTap;
  final Animation<double> pulseScale;
  final Animation<double> pulseOpacity;

  const ScannerControls({
    super.key,
    required this.onGalleryTap,
    required this.onCaptureTap,
    required this.pulseScale,
    required this.pulseOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: Colors.black.withValues(alpha: 0.45),
            padding: EdgeInsets.fromLTRB(
              32,
              20,
              32,
              MediaQuery.paddingOf(context).bottom + 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ControlButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: onGalleryTap,
                ),
                const SizedBox(width: 8),
                _CaptureButton(
                  onTap: onCaptureTap,
                  pulseScale: pulseScale,
                  pulseOpacity: pulseOpacity,
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 52,
                ), // Placeholder to balance gallery button
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final VoidCallback onTap;
  final Animation<double> pulseScale;
  final Animation<double> pulseOpacity;

  const _CaptureButton({
    required this.onTap,
    required this.pulseScale,
    required this.pulseOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseScale,
      builder: (context, child) => GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: pulseScale.value,
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: pulseOpacity.value * 0.5,
                    ),
                    width: 2,
                  ),
                ),
              ),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B8FE3), Color(0xFF55C7B5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B8FE3).withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
