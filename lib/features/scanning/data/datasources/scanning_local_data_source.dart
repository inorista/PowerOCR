import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

abstract class ScanningLocalDataSource {
  Future<TextRecognitionResult> recognizeText(String imagePath);
}

@LazySingleton(as: ScanningLocalDataSource)
class ScanningLocalDataSourceImpl implements ScanningLocalDataSource {
  @override
  Future<TextRecognitionResult> recognizeText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    
    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      
      final blocks = recognizedText.blocks.map((block) {
        return TextBlock(
          text: block.text,
          boundingBox: [
            block.boundingBox.left,
            block.boundingBox.top,
            block.boundingBox.right,
            block.boundingBox.bottom,
          ],
        );
      }).toList();

      return TextRecognitionResult(
        text: recognizedText.text,
        blocks: blocks,
      );
    } finally {
      await textRecognizer.close();
    }
  }
}
