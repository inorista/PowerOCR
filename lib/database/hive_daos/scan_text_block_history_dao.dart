import 'package:injectable/injectable.dart';
import 'package:powerocr/database/hive_daos/base_dao.dart';
import 'package:powerocr/database/hive_database.dart';
import 'package:powerocr/database/hive_entities/scan_text_block_history_entity/scan_text_block_history_entity.dart';

@lazySingleton
class ScanTextBlockHistoryDao extends BaseDao<ScanTextBlockHistoryEntity> {
  ScanTextBlockHistoryDao() : super(HiveBoxIds.scanTextBlockHistoryEntity);

  Future<List<ScanTextBlockHistoryEntity>> getScanTextBlockHistoryByScanId(
      String scanId) async {
    final items = await getAll();
    return items.where((element) => element.scanHistoryId == scanId).toList();
  }
}
