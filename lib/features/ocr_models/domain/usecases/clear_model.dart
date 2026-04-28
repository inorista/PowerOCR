import 'package:injectable/injectable.dart';
import 'package:powerocr/features/ocr_models/domain/repositories/ocr_model_repository.dart';

@lazySingleton
class ClearOcrModel {
  final OcrModelRepository ocrModelRepository;
  ClearOcrModel(this.ocrModelRepository);

  Future<void> call() async {
    return await ocrModelRepository.clearOcrModels();
  }
}
