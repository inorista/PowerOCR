import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_bloc.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_event.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class ScannerTopBar extends StatelessWidget {
  final FlashMode flashMode;
  final FeatureOption featureOption;

  const ScannerTopBar({
    super.key,
    required this.flashMode,
    required this.featureOption,
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
              _ScannerHint(featureOption: featureOption),
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
  final FeatureOption featureOption;
  const _ScannerHint({required this.featureOption});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (IconData icon, String label, Color accent) = _hintForMode(
      featureOption,
      l10n,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: accent, size: 14),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: accent, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  static (IconData, String, Color) _hintForMode(FeatureOption mode, AppLocalizations l10n) {
    return switch (mode) {
      FeatureOption.scanQR => (
        Icons.qr_code_rounded,
        l10n.scannerInstructionQr,
        const Color(0xFF06D6A0),
      ),
      FeatureOption.scanId => (
        Icons.credit_card_rounded,
        l10n.scannerInstructionId,
        const Color(0xFFFFD166),
      ),
      FeatureOption.batchScan => (
        Icons.layers_rounded,
        l10n.scannerInstructionBatch,
        const Color(0xFF8B8FE3),
      ),
      FeatureOption.scanDocument => (
        Icons.description_rounded,
        l10n.scannerInstructionDoc,
        const Color(0xFF8B8FE3),
      ),
    };
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
    final (IconData icon, Color color) = switch (mode) {
      FlashMode.off => (Icons.flash_off_rounded, Colors.white60),
      FlashMode.auto => (Icons.flash_auto_rounded, const Color(0xFF95E1D3)),
      FlashMode.always => (Icons.flash_on_rounded, const Color(0xFF8B8FE3)),
      FlashMode.torch => (Icons.flashlight_on_rounded, const Color(0xFFF38181)),
    };

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
