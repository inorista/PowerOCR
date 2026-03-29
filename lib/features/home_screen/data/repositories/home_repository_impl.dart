import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/features/home_screen/data/datasources/home_local_data_source.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/features/home_screen/domain/repositories/home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource = locator<HomeLocalDataSource>();

  HomeRepositoryImpl();

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
