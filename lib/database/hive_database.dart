import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart'
    show ScanHistoryEntityAdapter, ScanHistoryEntity;
import 'package:powerocr/database/hive_entities/scan_text_block_history_entity/scan_text_block_history_entity.dart';
import 'package:powerocr/database/hive_entities/theme_setting_entity/theme_setting_entity.dart';
import 'package:powerocr/database/hive_entities/user_qr_entity/user_qr_entity.dart';

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
    Hive.registerAdapter(ScanHistoryEntityAdapter());
    Hive.registerAdapter(ScanTextBlockHistoryEntityAdapter());
    Hive.registerAdapter(ScanHistoryTypeAdapter());
    Hive.registerAdapter(UserQrEntityAdapter());
  }

  Future<void> _initBoxes() async {
    await Hive.openBox<ThemeSettingEntity>(HiveBoxIds.themeSettingEntity);
    await Hive.openBox<ScanHistoryEntity>(HiveBoxIds.scanHistoryEntity);
    await Hive.openBox<ScanTextBlockHistoryEntity>(
      HiveBoxIds.scanTextBlockHistoryEntity,
    );
    await Hive.openBox<UserQrEntity>(HiveBoxIds.userQrEntity);
  }
}

class HiveBoxIds {
  static const themeSettingEntity = 'themeSettingEntity';
  static const scanHistoryEntity = 'scanHistoryEntity';
  static const scanTextBlockHistoryEntity = 'scanTextBlockHistoryEntity';
  static const userQrEntity = 'userQrEntity';
}

class HiveBoxNums {
  static const themeSettingEntity = 0;
  static const themeMode = 1;
  static const scanHistoryEntity = 2;
  static const scanTextBlockHistoryEntity = 3;
  static const scanHistoryType = 4;
  static const userQrEntity = 5;
}
