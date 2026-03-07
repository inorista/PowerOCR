import 'package:powerocr/core/constants/enum.dart';

abstract interface class IThemeSettingService {
  Future<ThemeModeOption> getThemeMode();
  Future<void> saveThemeMode(ThemeModeOption mode);
}
