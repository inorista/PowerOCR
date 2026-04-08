import 'package:injectable/injectable.dart';
import 'package:powerocr/database/hive_daos/base_dao.dart';
import 'package:powerocr/database/hive_database.dart';
import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart';

@lazySingleton
class ScanHistoryDao extends BaseDao<ScanHistoryEntity> {
  ScanHistoryDao() : super(HiveBoxIds.scanHistoryEntity);

  @override
  Future<ScanHistoryEntity?> getById(String id) async {
    ScanHistoryEntity? scanHistory = await super.getById(id);

    if (scanHistory == null) {
      final all = await getAll();
      scanHistory = all.where((e) => e.id == id).firstOrNull;
    }

    return scanHistory;
  }
}
