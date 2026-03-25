import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'
    as ml;
import 'package:injectable/injectable.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as ml_barcode;

abstract class ScanningLocalDataSource {
  Future<TextRecognitionResult> recognizeText(String imagePath);
  Future<TextRecognitionResult> recognizeQR(String imagePath);
}

@LazySingleton(as: ScanningLocalDataSource)
class ScanningLocalDataSourceImpl implements ScanningLocalDataSource {
  @override
  Future<TextRecognitionResult> recognizeQR(String imagePath) async {
    String barcodeText = '';
    try {
      final inputImage = ml_barcode.InputImage.fromFilePath(imagePath);
      final barcodeScanner = ml_barcode.BarcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);
      final barcodeStrings = barcodes
          .map((b) => b.displayValue ?? b.rawValue ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      if (barcodeStrings.isNotEmpty) {
        barcodeText = barcodeStrings.join('\n');
      }
      await barcodeScanner.close();
      return TextRecognitionResult(
        text: barcodeText,
        blocks: const [],
        imageWidth: 0,
        imageHeight: 0,
        imagePath: imagePath,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TextRecognitionResult> recognizeText(String imagePath) async {
    final inputImage = ml.InputImage.fromFilePath(imagePath);
    final textRecognizer = ml.TextRecognizer(
      script: ml.TextRecognitionScript.latin,
    );

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
