import 'package:injectable/injectable.dart';
import 'package:powerocr/database/hive_daos/base_dao.dart';
import 'package:powerocr/database/hive_database.dart';
import 'package:powerocr/database/hive_entities/theme_setting_entity/theme_setting_entity.dart';

@lazySingleton
class ThemeSettingDao extends BaseDao<ThemeSettingEntity> {
  ThemeSettingDao() : super(HiveBoxIds.themeSettingEntity);
}
