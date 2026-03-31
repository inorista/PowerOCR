import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/services/interfaces/iscan_history_service.dart';
import 'package:powerocr/database/hive_daos/scan_history_dao.dart';
import 'package:powerocr/database/hive_daos/scan_text_block_history_dao.dart';
import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart';
import 'package:powerocr/database/hive_entities/scan_text_block_history_entity/scan_text_block_history_entity.dart';

@LazySingleton(as: IScanHistoryService)
class ScanHistoryService implements IScanHistoryService {
  final scanHistoryDao = locator<ScanHistoryDao>();
  final scanTextBlockHistoryDao = locator<ScanTextBlockHistoryDao>();
  @override
  Future<void> addScanHistory(ScanHistoryEntity scanHistoryEntity) async {
    await scanHistoryDao.add(scanHistoryEntity);
  }

  @override
  Future<List<ScanHistoryEntity>> getScanHistory() async {
    return await scanHistoryDao.getAll();
  }

  @override
  Future<List<ScanTextBlockHistoryEntity>> getScanTextBlockHistoryByScanId(
      String scanId) async {
    return await scanTextBlockHistoryDao
        .getScanTextBlockHistoryByScanId(scanId);
  }

  @override
  Future<ScanHistoryEntity?> getScanHistoryById(String id) async {
    return await scanHistoryDao.getById(id);
  }

  @override
  Future<void> addScanTextBlockHistory(
      List<ScanTextBlockHistoryEntity> scanTextBlockHistoryEntities) async {
    await scanTextBlockHistoryDao.addAll(scanTextBlockHistoryEntities);
  }

  @override
  Future<void> updateScanHistory(ScanHistoryEntity scanHistoryEntity) async {
    await scanHistoryDao.update(scanHistoryEntity.id, scanHistoryEntity);
  }

  @override
  Future<void> deleteScanHistory(String id) async {
    await scanHistoryDao.delete(id);
  }
}
