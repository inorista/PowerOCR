import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/home/presentation/screens/widgets/quick_action.dart';
import 'package:powerocr/features/home/presentation/screens/widgets/quick_action_title.dart';

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
    final actions = [
      QuickAction(
        icon: Icons.camera_alt_rounded,
        label: 'Scan\nDocument',
        gradient: [const Color(0xFF8B8FE3), const Color(0xFF6B6FCC)],
        onTap: () {
          context.push(AppRouter.scanning, extra: FeatureOption.scanDocument);
        },
      ),
      QuickAction(
        icon: Icons.qr_code_scanner_rounded,
        label: 'Scan\nQR Code',
        gradient: [const Color(0xFFFFB7A3), const Color(0xFFE8896E)],
        onTap: () {
          context.push(AppRouter.scanning, extra: FeatureOption.scanQR);
        },
      ),
      QuickAction(
        icon: Icons.photo_library_rounded,
        label: 'Gallery\nImport',
        gradient: [const Color(0xFF95E1D3), const Color(0xFF5ABCAE)],
        onTap: () {},
      ),
      QuickAction(
        icon: Icons.photo_library_rounded,
        label: 'Gallery\nImport',
        gradient: [const Color(0xFF95E1D3), const Color(0xFF5ABCAE)],
        onTap: () {},
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
