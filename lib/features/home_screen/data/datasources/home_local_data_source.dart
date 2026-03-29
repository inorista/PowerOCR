import 'package:injectable/injectable.dart';
import 'package:powerocr/database/hive_daos/scan_history_dao.dart';
import 'package:powerocr/core/data/models/scan_history_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class HomeLocalDataSource {
  Future<List<ScanHistoryModel>> getScanHistory();
  Future<void> deleteScan(String id);
  Future<void> clearHistory();
}

@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final ScanHistoryDao _scanHistoryDao;

  HomeLocalDataSourceImpl(this._scanHistoryDao);

  @override
  Future<List<ScanHistoryModel>> getScanHistory() async {
    final entities = await _scanHistoryDao.getAll();
    entities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    try {
      final docDir = await getApplicationDocumentsDirectory();
      for (var entity in entities) {
        if (entity.imagePath.isNotEmpty) {
          if (!entity.imagePath.contains('/')) {
            entity.imagePath = '${docDir.path}/${entity.imagePath}';
          } else if (entity.imagePath.contains('/Documents/')) {
            final parts = entity.imagePath.split('/Documents/');
            if (parts.length > 1) {
              entity.imagePath = '${docDir.path}/${parts.last}';
            }
          }
        }
      }
    } catch (e) {
      // Ignore if document directory access fails
    }

    return ScanHistoryModel.fromHiveList(entities);
  }

  @override
  Future<void> deleteScan(String id) async {
    await _scanHistoryDao.delete(id);
  }

  @override
  Future<void> clearHistory() async {
    await _scanHistoryDao.clear();
  }
}
