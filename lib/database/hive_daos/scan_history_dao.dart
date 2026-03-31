import 'package:injectable/injectable.dart';
import 'package:powerocr/database/hive_daos/base_dao.dart';
import 'package:powerocr/database/hive_database.dart';
import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart';

@lazySingleton
class ScanHistoryDao extends BaseDao<ScanHistoryEntity> {
  ScanHistoryDao() : super(HiveBoxIds.scanHistoryEntity);
}
