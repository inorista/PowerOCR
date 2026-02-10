import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/services/interfaces/itheme_setting_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final _themeSettingService = locator<IThemeSettingService>();
  ThemeCubit() : super(const ThemeState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final option = await _themeSettingService.getThemeMode();
    emit(state.copyWith(themeMode: _mapOptionToMode(option)));
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _themeSettingService.saveThemeMode(_mapModeToOption(mode));
  }

  ThemeMode _mapOptionToMode(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }

  ThemeModeOption _mapModeToOption(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return ThemeModeOption.light;
      case ThemeMode.dark:
        return ThemeModeOption.dark;
      case ThemeMode.system:
        return ThemeModeOption.system;
    }
  }
}
