import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/environment/env.dart';
import 'package:powerocr/core/network/rest_client.dart';
import 'package:powerocr/features/scanning/data/models/annotate_image_request_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_feature_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_image_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_request_dto.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

abstract class ScanningRemoteDataSource {
  Future<TextRecognitionResult> recognizeText(String imagePath);
}

@LazySingleton(as: ScanningRemoteDataSource)
class ScanningRemoteDataSourceImpl implements ScanningRemoteDataSource {
  final RestClient restClient;

  ScanningRemoteDataSourceImpl(this.restClient);

  @override
  Future<TextRecognitionResult> recognizeText(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

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
        return const TextRecognitionResult(text: '');
      }
      if (firstResult.error != null) {
        print('Vision API Error: ${firstResult.error!.message}');
        return const TextRecognitionResult(text: '');
      }
      String detectedText = '';
      if (firstResult.textAnnotations != null &&
          firstResult.textAnnotations!.isNotEmpty) {
        detectedText = firstResult.textAnnotations![0].description ?? '';
      }
      return TextRecognitionResult(text: detectedText);
    } catch (e) {
      return const TextRecognitionResult(text: '');
    }
  }
}
