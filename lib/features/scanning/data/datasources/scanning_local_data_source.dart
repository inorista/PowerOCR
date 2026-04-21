import 'dart:developer' as dev;
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
    int displayWidth = 0;
    int displayHeight = 0;
    try {
      final bytes = await File(imagePath).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      displayWidth = frame.image.width;
      displayHeight = frame.image.height;
      frame.image.dispose();
    } catch (_) {}

    final inputImage = ml.InputImage.fromFilePath(imagePath);
    final textRecognizer = ml.TextRecognizer(
      script: ml.TextRecognitionScript.latin,
    );

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);

      double totalWordW = 0;
      double totalWordH = 0;
      double firstWordX = -1;
      double firstWordY = -1;

      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          for (final element in line.elements) {
            final bb = element.boundingBox;
            totalWordW += bb.width;
            totalWordH += bb.height;
            if (firstWordX == -1) {
              firstWordX = bb.left;
              firstWordY = bb.top;
            }
          }
        }
      }

      int rotationToApply = 0;
      final double displayW = displayWidth.toDouble();
      final double displayH = displayHeight.toDouble();

      if (totalWordW > 0 && totalWordH > totalWordW * 1.2) {
        if (firstWordX > displayH / 2) {
          rotationToApply = -90;
        } else {
          rotationToApply = 90;
        }
      } else if (totalWordW > 0) {
        if (firstWordY > displayH / 2 && firstWordX > displayW / 2) {
          rotationToApply = 180;
        }
      }

      final List<TextBlock> finalBlocks = [];
      for (final block in recognizedText.blocks) {
        final bb = block.boundingBox;
        final minX = bb.left;
        final minY = bb.top;
        final maxX = bb.right;
        final maxY = bb.bottom;

        double fMinX = minX;
        double fMinY = minY;
        double fMaxX = maxX;
        double fMaxY = maxY;

        if (rotationToApply == 90) {
          // ML Kit was (displayH x displayW). CW mapped to (displayW x displayH)
          fMinX = displayW - maxY;
          fMinY = minX;
          fMaxX = displayW - minY;
          fMaxY = maxX;
        } else if (rotationToApply == -90) {
          // CCW mapped to (displayW x displayH)
          fMinX = minY;
          fMinY = displayH - maxX;
          fMaxX = maxY;
          fMaxY = displayH - minX;
        } else if (rotationToApply == 180) {
          fMinX = displayW - maxX;
          fMinY = displayH - maxY;
          fMaxX = displayW - minX;
          fMaxY = displayH - minY;
        }

        finalBlocks.add(
          TextBlock(
            text: block.text,
            boundingBox: [fMinX, fMinY, fMaxX, fMaxY],
          ),
        );
      }

      return TextRecognitionResult(
        text: recognizedText.text,
        blocks: finalBlocks,
        imageWidth: displayWidth,
        imageHeight: displayHeight,
        createdAt: DateTime.now(),
        imagePath: imagePath,
        type: ScanHistoryType.document,
      );
    } finally {
      await textRecognizer.close();
    }
  }
}
