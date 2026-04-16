import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/core/utils/responsive.dart';
import 'package:powerocr/features/home_screen/presentation/screens/home_screen.dart';
import 'package:powerocr/features/main_screen/presentation/cubit/main_screen_cubit.dart';
import 'package:powerocr/features/main_screen/presentation/screen/widgets/bottom_navigation_item.dart';
import 'package:powerocr/features/qr_library/presentation/qr_library_screen/qr_library_screen.dart';
import 'package:powerocr/features/settings/presentation/screen/settings_screen.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = AppBreakpoints.isTablet(context);

    return BlocProvider<MainScreenCubit>(
      create: (context) => MainScreenCubit(),
      child: isTablet
          ? _TabletShell(l10n: l10n)
          : _PhoneShell(l10n: l10n),
    );
  }
}

// ─── Phone layout ────────────────────────────────────────────────────────────

class _PhoneShell extends StatelessWidget {
  const _PhoneShell({required this.l10n});
  final AppLocalizations l10n;

  static const _screens = [
    HomeScreen(),
    QrLibraryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<MainScreenCubit, MainScreenState>(
        builder: (context, state) => IndexedStack(
          index: state.screenIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 92,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    width: double.infinity,
                    height: 92,
                    color: Theme.of(context).colorScheme.surface.withAlpha(20),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 92,
              child: SafeArea(
                child: Row(
                  children: [
                    _buildNavItem(context, 0, l10n.homeTabHome, 'assets/images/home_icon.svg'),
                    _buildNavItem(context, 1, l10n.homeTabQr, 'assets/images/qr_icon.svg'),
                    _buildNavItem(context, 2, l10n.homeTabSetting, 'assets/images/setting_icon.svg'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String label,
    String iconPath,
  ) {
    return Expanded(
      child: BlocSelector<MainScreenCubit, MainScreenState, int>(
        selector: (state) => state.screenIndex,
        builder: (context, screenIndex) => BottomNavigationItem(
          onTap: () => context.read<MainScreenCubit>().changeScreen(index),
          isSelected: screenIndex == index,
          label: label,
          iconPath: iconPath,
        ),
      ),
    );
  }
}

// ─── Tablet layout ────────────────────────────────────────────────────────────

class _TabletShell extends StatelessWidget {
  const _TabletShell({required this.l10n});
  final AppLocalizations l10n;

  static const _screens = [
    HomeScreen(),
    QrLibraryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MainScreenCubit, MainScreenState>(
          builder: (context, state) {
            return Row(
              children: [
                // ── Side Navigation Rail ──────────────────────────────────
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1E2E).withValues(alpha: 0.85)
                            : Colors.white.withValues(alpha: 0.80),
                        border: Border(
                          right: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.07)
                                : Colors.black.withValues(alpha: 0.06),
                          ),
                        ),
                      ),
                      child: NavigationRail(
                        selectedIndex: state.screenIndex,
                        onDestinationSelected: (index) =>
                            context.read<MainScreenCubit>().changeScreen(index),
                        backgroundColor: Colors.transparent,
                        labelType: NavigationRailLabelType.all,
                        minWidth: 72,
                        groupAlignment: -0.8,
                        selectedIconTheme: IconThemeData(
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        unselectedIconTheme: IconThemeData(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                          size: 22,
                        ),
                        selectedLabelTextStyle: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelTextStyle: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                        destinations: [
                          NavigationRailDestination(
                            icon: const Icon(Icons.home_outlined),
                            selectedIcon: const Icon(Icons.home_rounded),
                            label: Text(l10n.homeTabHome),
                          ),
                          NavigationRailDestination(
                            icon: const Icon(Icons.qr_code_outlined),
                            selectedIcon: const Icon(Icons.qr_code_rounded),
                            label: Text(l10n.homeTabQr),
                          ),
                          NavigationRailDestination(
                            icon: const Icon(Icons.settings_outlined),
                            selectedIcon: const Icon(Icons.settings_rounded),
                            label: Text(l10n.homeTabSetting),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ── Main Content ─────────────────────────────────────────
                Expanded(
                  child: IndexedStack(
                    index: state.screenIndex,
                    children: _screens,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
