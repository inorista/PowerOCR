import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/features/scan_history_screen/data/datasource/scan_history_screen_data_source.dart';
import 'package:powerocr/features/scan_history_screen/domain/repositories/scan_history_screen_repository.dart';

@LazySingleton(as: ScanHistoryScreenRepository)
class ScanHistoryScreenRepositoryImpl implements ScanHistoryScreenRepository {
  final ScanHistoryScreenDataSource _dataSource =
      locator<ScanHistoryScreenDataSource>();
  ScanHistoryScreenRepositoryImpl();
  @override
  Future<List<ScanHistory>> getScanHistory() {
    return _dataSource.getScanHistory();
  }
}
