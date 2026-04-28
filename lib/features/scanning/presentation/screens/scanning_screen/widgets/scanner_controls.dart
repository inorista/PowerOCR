import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/features/ocr_models/presentation/widgets/custom_model_dropdown.dart'
    show CustomModelDropdown;
import 'package:powerocr/l10n/app_localizations.dart';

class ScannerControls extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCaptureTap;
  final FeatureOption featureOption;

  /// When [true] the capture button is hidden — scanning happens automatically.
  final bool isAutoScan;
  final bool isRequireModel;

  const ScannerControls({
    super.key,
    required this.onGalleryTap,
    required this.onCaptureTap,
    required this.featureOption,
    this.isAutoScan = false,
    this.isRequireModel = false,
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
                Expanded(
                  child: _ControlButton(
                    icon: Icons.photo_library_rounded,
                    label: AppLocalizations.of(context)!.scannerGalleryBtn,
                    onTap: onGalleryTap,
                  ),
                ),

                if (!isAutoScan)
                  Expanded(
                    child: _CaptureButton(
                      onTap: onCaptureTap,
                      featureOption: featureOption,
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),

                if (isRequireModel)
                  const Expanded(child: CustomModelDropdown())
                else
                  const Expanded(child: SizedBox()),
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
  final FeatureOption featureOption;

  const _CaptureButton({required this.onTap, required this.featureOption});

  @override
  Widget build(BuildContext context) {
    final (Color gradientA, Color gradientB, IconData icon) = _styleForMode(
      featureOption,
    );

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring — static, accent-coloured border
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: gradientA.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
          ),
          // Inner button
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [gradientA, gradientB],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradientA.withValues(alpha: 0.45),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  static (Color, Color, IconData) _styleForMode(FeatureOption mode) {
    return switch (mode) {
      FeatureOption.scanQR => (
        const Color(0xFF06D6A0),
        const Color(0xFF118AB2),
        Icons.qr_code_scanner_rounded,
      ),
      FeatureOption.scanId => (
        const Color(0xFFFFD166),
        const Color(0xFFEF8C4B),
        Icons.credit_card_rounded,
      ),
      FeatureOption.batchScan => (
        const Color(0xFF8B8FE3),
        const Color(0xFF55C7B5),
        Icons.add_photo_alternate_rounded,
      ),
      FeatureOption.scanDocument => (
        const Color(0xFF8B8FE3),
        const Color(0xFF55C7B5),
        Icons.camera_alt_rounded,
      ),
    };
  }
}
