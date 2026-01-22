import 'package:powerocr/features/scanning/data/models/vision_request_dto.dart';

abstract class INetworkService {
  Future<dynamic> sendRequestAnnotateImage(VisionRequestDto request);
}
