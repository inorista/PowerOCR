import 'package:powerocr/features/home/domain/entities/scan_history.dart';

abstract class HomeRepository {
  Future<List<ScanHistory>> getScanHistory();
  Future<void> deleteScan(String id);
  Future<void> clearHistory();
}
