import 'package:injectable/injectable.dart';
import 'package:powerocr/features/ocr_models/domain/entities/ocr_model.dart';
import 'package:powerocr/features/ocr_models/domain/repositories/ocr_model_repository.dart';

@lazySingleton
class GetModelLanguage {
  final OcrModelRepository ocrModelRepository;
  GetModelLanguage(this.ocrModelRepository);

  Future<List<OcrModel>> call() async {
    return await ocrModelRepository.getOcrModels();
  }
}
