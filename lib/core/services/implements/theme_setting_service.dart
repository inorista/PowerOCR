import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/services/interfaces/itheme_setting_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the selected [ThemeModeOption] in SharedPreferences.
///
/// Key: `'theme_mode'`
/// Values stored as plain strings: `'light'`, `'dark'`, `'system'` (default).
@LazySingleton(as: IThemeSettingService)
class ThemeSettingService implements IThemeSettingService {
  static const _key = 'theme_mode';

  @override
  Future<ThemeModeOption> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    return _parse(raw);
  }

  @override
  Future<void> saveThemeMode(ThemeModeOption mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _serialize(mode));
  }

  static String _serialize(ThemeModeOption mode) => switch (mode) {
    ThemeModeOption.light => 'light',
    ThemeModeOption.dark => 'dark',
    ThemeModeOption.system => 'system',
  };

  static ThemeModeOption _parse(String? raw) => switch (raw) {
    'light' => ThemeModeOption.light,
    'dark' => ThemeModeOption.dark,
    _ => ThemeModeOption.system, // default / unknown
  };
}

extension ThemeModeOptionX on ThemeModeOption {
  ThemeMode toFlutterThemeMode() => switch (this) {
    ThemeModeOption.light => ThemeMode.light,
    ThemeModeOption.dark => ThemeMode.dark,
    ThemeModeOption.system => ThemeMode.system,
  };
}
