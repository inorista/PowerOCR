import 'package:injectable/injectable.dart';
import 'package:powerocr/features/ocr_models/domain/repositories/ocr_model_repository.dart';

@lazySingleton
class SyncModelLanguage {
  final OcrModelRepository ocrModelRepository;
  SyncModelLanguage(this.ocrModelRepository);

  Future<void> call() async {
    return await ocrModelRepository.syncOcrModel();
  }
}
