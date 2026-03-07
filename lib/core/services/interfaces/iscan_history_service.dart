import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart';
import 'package:powerocr/database/hive_entities/scan_text_block_history_entity/scan_text_block_history_entity.dart';

abstract interface class IScanHistoryService {
  Future<List<ScanHistoryEntity>> getScanHistory();
  Future<ScanHistoryEntity?> getScanHistoryById(String id);
  Future<List<ScanTextBlockHistoryEntity>> getScanTextBlockHistoryByScanId(
      String scanId);
  Future<void> addScanHistory(ScanHistoryEntity scanHistory);
  Future<void> addScanTextBlockHistory(
      List<ScanTextBlockHistoryEntity> scanTextBlockHistoryEntities);
  Future<void> updateScanHistory(ScanHistoryEntity scanHistory);
  Future<void> deleteScanHistory(String id);
}
