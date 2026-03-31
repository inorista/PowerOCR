import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_bloc.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_event.dart';

class ScannerTopBar extends StatelessWidget {
  final FlashMode flashMode;

  const ScannerTopBar({
    super.key,
    required this.flashMode,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              _TopBarButton(
                icon: Icons.close_rounded,
                onTap: () => context.go(AppRouter.home),
              ),
              const Spacer(),
              const _ScannerHint(),
              const Spacer(),
              _FlashButton(
                mode: flashMode,
                onTap: () => context.read<ScanningBloc>().add(ToggleFlash()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerHint extends StatelessWidget {
  const _ScannerHint();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.qr_code_scanner_rounded, color: Colors.white70, size: 14),
              SizedBox(width: 6),
              Text(
                'Align document or QR code',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

class _FlashButton extends StatelessWidget {
  final FlashMode mode;
  final VoidCallback onTap;

  const _FlashButton({required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (mode) {
      case FlashMode.off:
        icon = Icons.flash_off_rounded;
        color = Colors.white60;
      case FlashMode.auto:
        icon = Icons.flash_auto_rounded;
        color = const Color(0xFF95E1D3);
      case FlashMode.always:
        icon = Icons.flash_on_rounded;
        color = const Color(0xFF8B8FE3);
      case FlashMode.torch:
        icon = Icons.flashlight_on_rounded;
        color = const Color(0xFFF38181);
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}
