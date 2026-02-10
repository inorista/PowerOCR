import 'package:powerocr/features/scanning/data/models/annotate_image_response_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_request_dto.dart';

abstract class INetworkService {
  Future<VisionApiResponseDto> sendRequestAnnotateImage(
      VisionRequestDto request);
}
