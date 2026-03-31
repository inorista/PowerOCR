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

    if (!isClosed) {
      emit(state.copyWith(themeMode: _mapOptionToMode(option)));
    }
  }

  void setTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));

    _themeSettingService.saveThemeMode(_mapModeToOption(mode)).ignore();
  }

  ThemeMode _mapOptionToMode(ThemeModeOption option) {
    return switch (option) {
      ThemeModeOption.light => ThemeMode.light,
      ThemeModeOption.dark => ThemeMode.dark,
      ThemeModeOption.system => ThemeMode.system,
    };
  }

  ThemeModeOption _mapModeToOption(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => ThemeModeOption.light,
      ThemeMode.dark => ThemeModeOption.dark,
      ThemeMode.system => ThemeModeOption.system,
    };
  }
}
