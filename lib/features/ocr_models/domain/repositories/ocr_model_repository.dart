import 'package:powerocr/features/ocr_models/data/models/ocr_model_dto.dart';
import 'package:powerocr/features/ocr_models/domain/entities/ocr_model.dart';

abstract class OcrModelRepository {
  Future<List<OcrModel>> getOcrModels();
  Future<void> saveOcrModels(List<OcrModelDto> ocrModelDtos);
  Future<void> deleteOcrModel(String id);
  Future<void> clearOcrModels();
  Future<void> syncOcrModel();
}
