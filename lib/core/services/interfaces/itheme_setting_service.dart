import 'package:powerocr/core/constants/enum.dart';

abstract class IThemeSettingService {
  Future<ThemeModeOption> getThemeMode();
  Future<void> saveThemeMode(ThemeModeOption mode);
}
