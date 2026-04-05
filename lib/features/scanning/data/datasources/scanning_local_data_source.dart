import 'dart:io';
import 'dart:ui' as ui;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'
    as ml;
import 'package:injectable/injectable.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/features/scanning/domain/entities/text_block.dart';
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
        type: ScanHistoryType.qr,
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

    int imageWidth = 0;
    int imageHeight = 0;
    try {
      final bytes = await File(imagePath).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      imageWidth = frameInfo.image.width;
      imageHeight = frameInfo.image.height;
    } catch (_) {}

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);

      double totalW = 0;
      double totalH = 0;
      double firstWordX = -1;
      double firstWordY = -1;

      List<List<double>> rawBlocks = [];
      List<String> blockTexts = [];

      for (final block in recognizedText.blocks) {
        final double minX = block.boundingBox.left;
        final double minY = block.boundingBox.top;
        final double maxX = block.boundingBox.right;
        final double maxY = block.boundingBox.bottom;

        if (firstWordX == -1) {
          firstWordX = minX;
          firstWordY = minY;
        }
        totalW += (maxX - minX);
        totalH += (maxY - minY);

        rawBlocks.add([minX, minY, maxX, maxY]);
        blockTexts.add(block.text);
      }

      int rotation = 0;
      double rawW = imageWidth.toDouble();
      double rawH = imageHeight.toDouble();

      if (totalW > 0 && totalH > totalW * 1.2) {
        rawW = imageHeight.toDouble();
        rawH = imageWidth.toDouble();
        if (firstWordY > rawH / 2) {
          rotation = -90;
        } else {
          rotation = 90;
        }
      } else if (totalW > 0) {
        if (firstWordX > rawW / 2 && firstWordY > rawH / 2) {
          rotation = 180;
        }
      }

      List<TextBlock> finalBlocks = [];
      for (int i = 0; i < rawBlocks.length; i++) {
        double minX = rawBlocks[i][0];
        double minY = rawBlocks[i][1];
        double maxX = rawBlocks[i][2];
        double maxY = rawBlocks[i][3];

        double finalMinX = minX,
            finalMinY = minY,
            finalMaxX = maxX,
            finalMaxY = maxY;

        if (rotation == -90) {
          finalMinX = rawH - maxY;
          finalMinY = minX;
          finalMaxX = rawH - minY;
          finalMaxY = maxX;
        } else if (rotation == 90) {
          finalMinX = minY;
          finalMinY = rawW - maxX;
          finalMaxX = maxY;
          finalMaxY = rawW - minX;
        } else if (rotation == 180) {
          finalMinX = rawW - maxX;
          finalMinY = rawH - maxY;
          finalMaxX = rawW - minX;
          finalMaxY = rawH - minY;
        }

        finalBlocks.add(
          TextBlock(
            text: blockTexts[i],
            boundingBox: [finalMinX, finalMinY, finalMaxX, finalMaxY],
          ),
        );
      }

      return TextRecognitionResult(
        text: recognizedText.text,
        blocks: finalBlocks,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        createdAt: DateTime.now(),
        imagePath: imagePath,
        type: ScanHistoryType.document,
      );
    } finally {
      await textRecognizer.close();
    }
  }
}
