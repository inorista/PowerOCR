import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/network/powerocr_rest_client.dart'
    show PowerOCRRestClient;
import 'package:powerocr/features/ocr_models/data/datasource/ocr_model_local_datasource.dart';
import 'package:powerocr/features/ocr_models/data/models/ocr_model_dto.dart'
    show OcrModelDto;
import 'package:powerocr/features/ocr_models/domain/entities/ocr_model.dart';
import 'package:powerocr/features/ocr_models/domain/repositories/ocr_model_repository.dart'
    show OcrModelRepository;

@LazySingleton(as: OcrModelRepository)
class OcrModelRepositoryImpl implements OcrModelRepository {
  final OcrModelLocalDataSource localDataSource;

  OcrModelRepositoryImpl({required this.localDataSource});

  @override
  Future<void> clearOcrModels() async {
    return await localDataSource.clearOcrModels();
  }

  @override
  Future<void> deleteOcrModel(String id) async {
    return await localDataSource.deleteOcrModel(id);
  }

  @override
  Future<List<OcrModel>> getOcrModels() async {
    return await localDataSource.getOcrModels();
  }

  @override
  Future<void> saveOcrModels(List<OcrModelDto> ocrModelDto) async {
    return await localDataSource.saveOcrModels(ocrModelDto);
  }

  @override
  Future<void> syncOcrModel() async {
    final dtos = await locator<PowerOCRRestClient>().getModels();
    await saveOcrModels(dtos);
  }
}
