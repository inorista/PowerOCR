import 'package:hive_ce/hive.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/database/base_entity.dart';
import 'package:powerocr/database/hive_database.dart';

part 'theme_setting_entity.g.dart';

@HiveType(typeId: HiveBoxNums.themeSettingEntity)
class ThemeSettingEntity extends BaseEntity {
  @HiveField(1)
  ThemeModeOption themeMode;

  ThemeSettingEntity({
    super.id,
    required this.themeMode,
  });
}
