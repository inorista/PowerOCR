import 'package:powerocr/core/domain/entities/scan_history.dart';

abstract class HomeRepository {
  Future<List<ScanHistory>> getScanHistory();
  Future<void> deleteScan(String id);
  Future<void> clearHistory();
}
