import 'package:injectable/injectable.dart';
import 'package:powerocr/database/hive_daos/scan_history_dao.dart';
import 'package:powerocr/features/home/data/models/scan_history_model.dart';

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
