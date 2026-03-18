import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

abstract class ScanningRepository {
  Future<TextRecognitionResult> recognizeText(String imagePath);
  Future<void> saveScanHistory(TextRecognitionResult result);
}
