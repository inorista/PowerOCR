import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/services/interfaces/inetwork_service.dart';
import 'package:powerocr/features/scanning/data/models/annotate_image_request_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_feature_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_image_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_request_dto.dart';

void main() async {
  await configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: InkWell(
          onTap: () async {
            final image = await rootBundle.load(
              'assets/images/81a7e64979fcfcabd327c3fe23d9c808.jpg',
            );
            final bytes = image.buffer.asUint8List();
            final base64 = base64Encode(bytes);

            final request = AnnotateImageRequestDto(
              image: VisionImageDto(content: base64),
              features: [
                VisionFeatureDto(type: VisionFeatureType.documentTextDetection),
              ],
            );
            final mainRequest = VisionRequestDto(requests: [request]);
            locator<INetworkService>().sendRequestAnnotateImage(mainRequest);
          },
          child: Center(child: Text('Hello World!')),
        ),
      ),
    );
  }
}
