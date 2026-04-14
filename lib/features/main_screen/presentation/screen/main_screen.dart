import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/features/home_screen/presentation/screens/home_screen.dart';
import 'package:powerocr/features/main_screen/presentation/cubit/main_screen_cubit.dart';
import 'package:powerocr/features/main_screen/presentation/screen/widgets/bottom_navigation_item.dart';
import 'package:powerocr/features/settings/presentation/settings_screen.dart';
import 'package:powerocr/l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<MainScreenCubit>(
      create: (context) => MainScreenCubit(),
      child: Scaffold(
        extendBody: true,
        body: BlocBuilder<MainScreenCubit, MainScreenState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.screenIndex,
              children: const [
                HomeScreen(),
                SettingsScreen(),
                SettingsScreen(),
              ],
            );
          },
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
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withAlpha(20),
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
                      Expanded(
                        child:
                            BlocSelector<MainScreenCubit, MainScreenState, int>(
                              selector: (state) {
                                return state.screenIndex;
                              },
                              builder: (context, screenIndex) {
                                return BottomNavigationItem(
                                  onTap: () {
                                    context
                                        .read<MainScreenCubit>()
                                        .changeScreen(0);
                                  },
                                  isSelected: screenIndex == 0,
                                  label: l10n.homeTabHome,
                                  iconPath: 'assets/images/home_icon.svg',
                                );
                              },
                            ),
                      ),
                      Expanded(
                        child:
                            BlocSelector<MainScreenCubit, MainScreenState, int>(
                              selector: (state) {
                                return state.screenIndex;
                              },
                              builder: (context, screenIndex) {
                                return BottomNavigationItem(
                                  onTap: () {
                                    context
                                        .read<MainScreenCubit>()
                                        .changeScreen(1);
                                  },
                                  isSelected: screenIndex == 1,
                                  label: l10n.homeTabQr,
                                  iconPath: 'assets/images/qr_icon.svg',
                                );
                              },
                            ),
                      ),
                      Expanded(
                        child:
                            BlocSelector<MainScreenCubit, MainScreenState, int>(
                              selector: (state) {
                                return state.screenIndex;
                              },
                              builder: (context, screenIndex) {
                                return BottomNavigationItem(
                                  onTap: () {
                                    context
                                        .read<MainScreenCubit>()
                                        .changeScreen(2);
                                  },
                                  isSelected: screenIndex == 2,
                                  label: l10n.homeTabSetting,
                                  iconPath: 'assets/images/setting_icon.svg',
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
