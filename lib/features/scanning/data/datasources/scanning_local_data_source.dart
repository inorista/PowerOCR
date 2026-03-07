import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'
    as ml;
import 'package:injectable/injectable.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

abstract class ScanningLocalDataSource {
  Future<TextRecognitionResult> recognizeText(String imagePath);
}

@LazySingleton(as: ScanningLocalDataSource)
class ScanningLocalDataSourceImpl implements ScanningLocalDataSource {
  @override
  Future<TextRecognitionResult> recognizeText(String imagePath) async {
    final inputImage = ml.InputImage.fromFilePath(imagePath);
    final textRecognizer =
        ml.TextRecognizer(script: ml.TextRecognitionScript.latin);

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
        createdAt: DateTime.now(),
        imagePath: imagePath,
      );
    } finally {
      await textRecognizer.close();
    }
  }
}
