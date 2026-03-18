import 'package:injectable/injectable.dart';
import 'package:powerocr/features/home/data/datasources/home_local_data_source.dart';
import 'package:powerocr/features/home/domain/entities/scan_history.dart';
import 'package:powerocr/features/home/domain/repositories/home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl(this.localDataSource);

  @override
  Future<List<ScanHistory>> getScanHistory() async {
    return await localDataSource.getScanHistory();
  }

  @override
  Future<void> deleteScan(String id) async {
    await localDataSource.deleteScan(id);
  }

  @override
  Future<void> clearHistory() async {
    await localDataSource.clearHistory();
  }
}
