import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:injectable/injectable.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'
    as ml;
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/environment/env.dart';
import 'package:powerocr/core/network/rest_client.dart';
import 'package:powerocr/features/scanning/data/models/annotate_image_request_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_feature_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_image_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_request_dto.dart';
import 'package:powerocr/features/scanning/domain/entities/text_block.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:powerocr/core/network/powerocr_rest_client.dart';
import 'package:powerocr/features/scanning/data/models/powerocr_request_dto.dart';

abstract class ScanningRemoteDataSource {
  Future<TextRecognitionResult> recognizeText(String imagePath);
}

@LazySingleton(as: ScanningRemoteDataSource)
class ScanningRemoteDataSourceImpl implements ScanningRemoteDataSource {
  final RestClient restClient;

  ScanningRemoteDataSourceImpl(this.restClient);

  Future<TextRecognitionResult> _processVisionAI(String imagePath) async {
    try {
      final inputImage = ml.InputImage.fromFilePath(imagePath);
      final textRecognizer = ml.TextRecognizer(
        script: ml.TextRecognitionScript.latin,
      );
      try {
        final localResult = await textRecognizer.processImage(inputImage);
        if (localResult.text.trim().isEmpty) {
          return TextRecognitionResult(
            text: '',
            blocks: const [],
            imageWidth: 0,
            imageHeight: 0,
            createdAt: DateTime.now(),
            imagePath: imagePath,
            type: ScanHistoryType.document,
          );
        }
      } finally {
        await textRecognizer.close();
      }

      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      final int imageWidth = frameInfo.image.width;
      final int imageHeight = frameInfo.image.height;

      final request = VisionRequestDto(
        requests: [
          AnnotateImageRequestDto(
            image: VisionImageDto(content: base64Image),
            features: [
              VisionFeatureDto(type: VisionFeatureType.textDetection),
              VisionFeatureDto(type: VisionFeatureType.documentTextDetection),
            ],
          ),
        ],
      );

      final response = await getRestClient().sendRequestAnnotateImage(
        request,
        Env.apiKey,
      );

      final firstResult = response.responses?.firstOrNull;
      if (firstResult == null) {
        return TextRecognitionResult(
          text: '',
          imagePath: imagePath,
          createdAt: DateTime.now(),
          type: ScanHistoryType.document,
        );
      }
      if (firstResult.error != null) {
        print('Vision API Error: ${firstResult.error!.message}');
        return TextRecognitionResult(
          text: '',
          imagePath: imagePath,
          createdAt: DateTime.now(),
          type: ScanHistoryType.document,
        );
      }
      String detectedText = '';
      List<TextBlock> detectedBlocks = [];
      if (firstResult.textAnnotations != null &&
          firstResult.textAnnotations!.isNotEmpty) {
        detectedText = firstResult.textAnnotations![0].description ?? '';

        double totalW = 0;
        double totalH = 0;
        double firstWordX = -1;
        double firstWordY = -1;

        List<List<double>> rawBlocks = [];
        List<String> blockTexts = [];

        for (int i = 1; i < firstResult.textAnnotations!.length; i++) {
          final ann = firstResult.textAnnotations![i];
          final text = ann.description ?? '';
          final poly = ann.boundingPoly;
          if (poly != null &&
              poly.vertices != null &&
              poly.vertices!.isNotEmpty) {
            double minX = double.infinity;
            double minY = double.infinity;
            double maxX = double.negativeInfinity;
            double maxY = double.negativeInfinity;
            for (final v in poly.vertices!) {
              final vx = (v.x ?? 0).toDouble();
              final vy = (v.y ?? 0).toDouble();
              if (vx < minX) minX = vx;
              if (vy < minY) minY = vy;
              if (vx > maxX) maxX = vx;
              if (vy > maxY) maxY = vy;
            }
            if (minX == double.infinity) minX = 0;
            if (minY == double.infinity) minY = 0;
            if (maxX == double.negativeInfinity) maxX = 0;
            if (maxY == double.negativeInfinity) maxY = 0;

            if (firstWordX == -1) {
              firstWordX = minX;
              firstWordY = minY;
            }

            totalW += (maxX - minX);
            totalH += (maxY - minY);

            rawBlocks.add([minX, minY, maxX, maxY]);
            blockTexts.add(text);
          }
        }

        int rotation = 0; // 0: upright, 90: CW, -90: CCW, 180: upside down
        double rawW = imageWidth.toDouble();
        double rawH = imageHeight.toDouble();

        // If bounding boxes are predominantly tall and narrow, it means text was read sideways
        if (totalW > 0 && totalH > totalW * 1.2) {
          rawW = imageHeight.toDouble();
          rawH = imageWidth.toDouble();
          if (firstWordY > rawH / 2) {
            rotation = -90; // Top-left word is at bottom edge -> CCW
          } else {
            rotation = 90; // CW
          }
        } else if (totalW > 0) {
          if (firstWordX > rawW / 2 && firstWordY > rawH / 2) {
            rotation = 180;
          }
        }

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
            // CCW -> unrotate by CW
            finalMinX = rawH - maxY;
            finalMinY = minX;
            finalMaxX = rawH - minY;
            finalMaxY = maxX;
          } else if (rotation == 90) {
            // CW -> unrotate by CCW
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

          detectedBlocks.add(
            TextBlock(
              text: blockTexts[i],
              boundingBox: [finalMinX, finalMinY, finalMaxX, finalMaxY],
            ),
          );
        }
      }
      return TextRecognitionResult(
        text: detectedText,
        blocks: detectedBlocks,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        createdAt: DateTime.now(),
        imagePath: imagePath,
        type: ScanHistoryType.document,
      );
    } catch (e) {
      return TextRecognitionResult(
        text: '',
        imagePath: imagePath,
        createdAt: DateTime.now(),
        type: ScanHistoryType.document,
      );
    }
  }

  Future<String> _detectLanguageFromImage(String imagePath) async {
    final inputImage = ml.InputImage.fromFilePath(imagePath);
    final textRecognizer = ml.TextRecognizer(
      script: ml.TextRecognitionScript.latin,
    );

    try {
      final localResult = await textRecognizer.processImage(inputImage);
      final text = localResult.text.trim();

      if (text.isEmpty) {
        return 'en';
      }

      final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
      final String mlkitCode = await languageIdentifier.identifyLanguage(text);
      await languageIdentifier.close();

      // Normalize ML Kit's BCP-47 code (e.g., 'zh-Hans', 'en-US' -> 'zh', 'en')
      final String baseCode = mlkitCode
          .split('-')
          .first
          .split('_')
          .first
          .toLowerCase();

      // Map to BE custom language codes
      switch (baseCode) {
        case 'vi':
          return 'vi';
        case 'zh':
        case 'cmn':
        case 'yue':
          return 'zh';
        case 'ko':
          return 'ko';
        case 'la':
          return 'la';
        case 'ar':
          return 'ar';
        case 'ja':
          return 'ja';
        case 'en':
        default:
          return 'en';
      }
    } catch (e) {
      return 'en';
    } finally {
      await textRecognizer.close();
    }
  }

  Future<TextRecognitionResult> _processPowerOCR(String imagePath) async {
    try {
      final detectedLang = await _detectLanguageFromImage(imagePath);

      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      final int imageWidth = frameInfo.image.width;
      final int imageHeight = frameInfo.image.height;

      final request = PowerOCRRequestDto(
        base64String: base64Image,
        lang: detectedLang,
      );

      final response = await locator<PowerOCRRestClient>().scanBase64(request);

      if (response.status != 'success') {
        return TextRecognitionResult(
          text: '',
          imagePath: imagePath,
          createdAt: DateTime.now(),
          type: ScanHistoryType.document,
        );
      }

      String detectedText = response.totalText;
      List<TextBlock> detectedBlocks = [];

      double totalW = 0;
      double totalH = 0;
      double firstWordX = -1;
      double firstWordY = -1;

      List<List<double>> rawBlocks = [];
      List<String> blockTexts = [];

      if (response.data.isNotEmpty) {
        for (final item in response.data) {
          final box = item.box;
          final text = item.text;

          if (box.isNotEmpty) {
            double minX = double.infinity;
            double minY = double.infinity;
            double maxX = double.negativeInfinity;
            double maxY = double.negativeInfinity;

            for (final pt in box) {
              final vx = pt[0].toDouble();
              final vy = pt[1].toDouble();
              if (vx < minX) minX = vx;
              if (vy < minY) minY = vy;
              if (vx > maxX) maxX = vx;
              if (vy > maxY) maxY = vy;
            }

            if (minX == double.infinity) minX = 0;
            if (minY == double.infinity) minY = 0;
            if (maxX == double.negativeInfinity) maxX = 0;
            if (maxY == double.negativeInfinity) maxY = 0;

            if (firstWordX == -1) {
              firstWordX = minX;
              firstWordY = minY;
            }

            totalW += (maxX - minX);
            totalH += (maxY - minY);

            rawBlocks.add([minX, minY, maxX, maxY]);
            blockTexts.add(text);
          }
        }

        int rotation = 0; // 0: upright, 90: CW, -90: CCW, 180: upside down
        double rawW = imageWidth.toDouble();
        double rawH = imageHeight.toDouble();

        // If bounding boxes are predominantly tall and narrow, it means text was read sideways
        if (totalW > 0 && totalH > totalW * 1.2) {
          rawW = imageHeight.toDouble();
          rawH = imageWidth.toDouble();
          if (firstWordY > rawH / 2) {
            rotation = -90; // Top-left word is at bottom edge -> CCW
          } else {
            rotation = 90; // CW
          }
        } else if (totalW > 0) {
          if (firstWordX > rawW / 2 && firstWordY > rawH / 2) {
            rotation = 180;
          }
        }

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
            // CCW -> unrotate by CW
            finalMinX = rawH - maxY;
            finalMinY = minX;
            finalMaxX = rawH - minY;
            finalMaxY = maxX;
          } else if (rotation == 90) {
            // CW -> unrotate by CCW
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

          detectedBlocks.add(
            TextBlock(
              text: blockTexts[i],
              boundingBox: [finalMinX, finalMinY, finalMaxX, finalMaxY],
            ),
          );
        }
      }

      return TextRecognitionResult(
        text: detectedText,
        blocks: detectedBlocks,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        createdAt: DateTime.now(),
        imagePath: imagePath,
        type: ScanHistoryType.document,
      );
    } catch (e) {
      print('PowerOCR API Error: $e');
      return TextRecognitionResult(
        text: '',
        imagePath: imagePath,
        createdAt: DateTime.now(),
        type: ScanHistoryType.document,
      );
    }
  }

  @override
  Future<TextRecognitionResult> recognizeText(String imagePath) async {
    try {
      return await _processPowerOCR(imagePath);
    } catch (e) {
      return await _processVisionAI(imagePath);
    }
  }
}
