import 'package:injectable/injectable.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/services/interfaces/itheme_setting_service.dart';
import 'package:powerocr/database/hive_daos/theme_setting_dao.dart';
import 'package:powerocr/database/hive_entities/theme_setting_entity/theme_setting_entity.dart';

@LazySingleton(as: IThemeSettingService)
class ThemeSettingService implements IThemeSettingService {
  final ThemeSettingDao _themeSettingDao;
  static const String _themeKey = 'theme_settings';

  ThemeSettingService(this._themeSettingDao);

  @override
  Future<ThemeModeOption> getThemeMode() async {
    final entity = await _themeSettingDao.get(_themeKey);
    return entity?.themeMode ?? ThemeModeOption.system;
  }

  @override
  Future<void> saveThemeMode(ThemeModeOption mode) async {
    final entity = ThemeSettingEntity(themeMode: mode);
    await _themeSettingDao.update(_themeKey, entity);
  }
}
