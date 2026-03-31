import 'package:powerocr/core/domain/entities/scan_history.dart';

abstract class ScanHistoryScreenRepository {
  Future<List<ScanHistory>> getScanHistory();
}
