import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/database/hive_entities/ocr_model_entity/ocr_model_entity.dart'
    show OcrModelEntityAdapter;
import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart'
    show ScanHistoryEntityAdapter, ScanHistoryEntity;
import 'package:powerocr/database/hive_entities/scan_text_block_history_entity/scan_text_block_history_entity.dart';
import 'package:powerocr/database/hive_entities/user_qr_entity/user_qr_entity.dart';

class HiveDatabase {
  Future<void> setupHiveDatabase() async {
    Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    _registerAdapters();
    await _initBoxes();
  }

  void _registerAdapters() {
    Hive.registerAdapter(ScanHistoryEntityAdapter());
    Hive.registerAdapter(ScanTextBlockHistoryEntityAdapter());
    Hive.registerAdapter(ScanHistoryTypeAdapter());
    Hive.registerAdapter(UserQrEntityAdapter());
    Hive.registerAdapter(OcrModelEntityAdapter());
  }

  Future<void> _initBoxes() async {
    await Hive.openBox<ScanHistoryEntity>(HiveBoxIds.scanHistoryEntity);
    await Hive.openBox<ScanTextBlockHistoryEntity>(
      HiveBoxIds.scanTextBlockHistoryEntity,
    );
    await Hive.openBox<UserQrEntity>(HiveBoxIds.userQrEntity);
  }
}

class HiveBoxIds {
  static const scanHistoryEntity = 'scanHistoryEntity';
  static const scanTextBlockHistoryEntity = 'scanTextBlockHistoryEntity';
  static const userQrEntity = 'userQrEntity';
  static const ocrModelEntity = 'ocrModelEntity';
}

class HiveBoxNums {
  static const themeSettingEntity = 0;
  static const themeMode = 1;
  static const scanHistoryEntity = 2;
  static const scanTextBlockHistoryEntity = 3;
  static const scanHistoryType = 4;
  static const userQrEntity = 5;
  static const ocrModelEntity = 6;
}
