import 'package:injectable/injectable.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:powerocr/features/scanning/domain/repositories/scanning_repository.dart';

@lazySingleton
class RecognizeText {
  final ScanningRepository repository;

  RecognizeText(this.repository);

  Future<TextRecognitionResult> call(String imagePath) {
    return repository.recognizeText(imagePath);
  }
}
