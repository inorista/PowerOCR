import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/quick_action.dart';
import 'package:powerocr/features/home_screen/presentation/screens/widgets/quick_action_title.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class QuickActionsGrid extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;

  const QuickActionsGrid({
    super.key,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final actions = [
      QuickAction(
        icon: Icons.camera_alt_rounded,
        label: l10n.homeQuickScanDoc,
        gradient: [const Color(0xFF8B8FE3), const Color(0xFF6B6FCC)],
        onTap: () {
          context.push(AppRouter.scanning, extra: FeatureOption.scanDocument);
        },
      ),
      QuickAction(
        icon: Icons.qr_code_scanner_rounded,
        label: l10n.homeQuickScanId,
        gradient: [const Color(0xFFFFB7A3), const Color(0xFFE8896E)],
        onTap: () {
          context.push(AppRouter.scanning, extra: FeatureOption.scanQR);
        },
      ),
      QuickAction(
        icon: Icons.picture_as_pdf, // Batch Scan Icon
        label: l10n.homeQuickScanBatch,
        gradient: [const Color(0xFF95E1D3), const Color(0xFF5ABCAE)],
        onTap: () {
          context.push(AppRouter.scanning, extra: FeatureOption.batchScan);
        },
      ),
      QuickAction(
        icon: Icons.qr_code_outlined, // Scan ID Icon
        label: l10n.homeQuickGenerateQr,
        gradient: [const Color(0xFFCBAACB), const Color(0xFF9F83A0)],
        onTap: () {
          context.push(AppRouter.generateQr);
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 100,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return QuickActionTile(action: action, isDark: isDark, theme: theme);
        },
      ),
    );
  }
}
