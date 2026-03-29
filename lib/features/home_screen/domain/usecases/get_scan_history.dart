import 'package:injectable/injectable.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/features/home_screen/domain/repositories/home_repository.dart';

@lazySingleton
class GetScanHistory {
  final HomeRepository repository;

  GetScanHistory(this.repository);

  Future<List<ScanHistory>> call() async {
    return await repository.getScanHistory();
  }
}
