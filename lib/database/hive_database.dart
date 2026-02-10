import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/database/hive_entities/theme_setting_entity/theme_setting_entity.dart';

class HiveDatabase {
  Future<void> setupHiveDatabase() async {
    Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    _registerAdapters();
    await _initBoxes();
  }

  void _registerAdapters() {
    Hive.registerAdapter(ThemeSettingEntityAdapter());
    Hive.registerAdapter(ThemeModeOptionAdapter());
  }

  Future<void> _initBoxes() async {
    await Hive.openBox<ThemeSettingEntity>(HiveBoxIds.themeSettingEntity);
  }
}

class HiveBoxIds {
  static const themeSettingEntity = 'themeSettingEntity';
}

class HiveBoxNums {
  static const themeSettingEntity = 0;
  static const themeMode = 1;
}
