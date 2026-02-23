import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/features/scanning/data/datasources/scanning_local_data_source.dart';
import 'package:powerocr/features/scanning/data/datasources/scanning_remote_data_source.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:powerocr/features/scanning/domain/repositories/scanning_repository.dart';

@LazySingleton(as: ScanningRepository)
class ScanningRepositoryImpl implements ScanningRepository {
  final ScanningRemoteDataSource remoteDataSource;
  final ScanningLocalDataSource localDataSource;
  final Connectivity connectivity;

  ScanningRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<TextRecognitionResult> recognizeText(String imagePath) async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return localDataSource.recognizeText(imagePath);
    } else {
      try {
        return await remoteDataSource.recognizeText(imagePath);
      } catch (e) {
        return localDataSource.recognizeText(imagePath);
      }
    }
  }
}
