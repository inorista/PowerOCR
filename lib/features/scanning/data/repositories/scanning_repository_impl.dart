import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/services/interfaces/iscan_history_service.dart';
import 'package:powerocr/features/scanning/data/datasources/scanning_local_data_source.dart';
import 'package:powerocr/features/scanning/data/datasources/scanning_remote_data_source.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:powerocr/features/scanning/domain/repositories/scanning_repository.dart';

@LazySingleton(as: ScanningRepository)
class ScanningRepositoryImpl implements ScanningRepository {
  final ScanningRemoteDataSource remoteDataSource;
  final ScanningLocalDataSource localDataSource;
  final Connectivity connectivity;
  final IScanHistoryService scanHistoryService = locator<IScanHistoryService>();
  ScanningRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<TextRecognitionResult> recognizeQR(String imagePath) async {
    try {
      return await localDataSource.recognizeQR(imagePath);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TextRecognitionResult> recognizeText(String imagePath) async {
    final connectivityResult = await connectivity.checkConnectivity();

    TextRecognitionResult result;
    if (connectivityResult.contains(ConnectivityResult.none)) {
      result = await localDataSource.recognizeText(imagePath);
    } else {
      try {
        result = await remoteDataSource.recognizeText(imagePath);
      } catch (e) {
        result = await localDataSource.recognizeText(imagePath);
      }
    }
    return result;
  }

  @override
  Future<void> saveScanHistory(TextRecognitionResult result) async {
    String finalImagePath = result.imagePath;

    if (finalImagePath.isNotEmpty) {
      try {
        final docDir = await getApplicationDocumentsDirectory();
        final originalFile = File(finalImagePath);

        if (await originalFile.exists()) {
          final fileName =
              'ocr_scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
          await originalFile.copy('${docDir.path}/$fileName');

          finalImagePath = fileName;
        }
      } catch (e) {
        // Ignore if file copying fails
      }
    }

    final processedResult = TextRecognitionResult(
      text: result.text,
      blocks: result.blocks,
      imageWidth: result.imageWidth,
      imageHeight: result.imageHeight,
      imagePath: finalImagePath,
      createdAt: result.createdAt,
      type: result.type,
    );

    final scanHistoryEntity = TextRecognitionResult.toScanHistoryEntity(
      processedResult,
    );
    final scanTextBlockHistoryEntities =
        TextRecognitionResult.toScanTextBlockHistoryEntities(
          processedResult,
          scanHistoryEntity.id,
        );

    await scanHistoryService.addScanHistory(scanHistoryEntity);
    await scanHistoryService.addScanTextBlockHistory(
      scanTextBlockHistoryEntities,
    );
  }
}
