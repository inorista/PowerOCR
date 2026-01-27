import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:powerocr/core/constants/enum.dart';
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
    final bytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final request = VisionRequestDto(
      requests: [
        AnnotateImageRequestDto(
          image: VisionImageDto(content: base64Image),
          features: [
            VisionFeatureDto(type: VisionFeatureType.TEXT_DETECTION),
            VisionFeatureDto(type: VisionFeatureType.DOCUMENT_TEXT_DETECTION),
          ],
        ),
      ],
    );

    final response = await restClient.sendRequestAnnotateImage(
      request,
      Env.apiKey,
    );

    // Parse response
    if (response != null &&
        response['responses'] != null &&
        (response['responses'] as List).isNotEmpty) {
      final firstResponse = response['responses'][0];
      final fullTextAnnotation = firstResponse['fullTextAnnotation'];
      
      if (fullTextAnnotation != null) {
        final text = fullTextAnnotation['text'] as String;
        // Parse blocks if needed, for now just returning full text
        return TextRecognitionResult(text: text);
      } else if (firstResponse['textAnnotations'] != null) {
          final textAnnotations = firstResponse['textAnnotations'] as List;
          if (textAnnotations.isNotEmpty) {
             final text = textAnnotations[0]['description'] as String;
             return TextRecognitionResult(text: text);
          }
      }
    }
    
    return const TextRecognitionResult(text: '');
  }
}
