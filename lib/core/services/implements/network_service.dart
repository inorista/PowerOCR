import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/environment/env.dart';
import 'package:powerocr/core/services/interfaces/inetwork_service.dart';
import 'package:powerocr/features/scanning/data/models/annotate_image_response_dto.dart';
import 'package:powerocr/features/scanning/data/models/vision_request_dto.dart';

@LazySingleton(as: INetworkService)
class NetworkService implements INetworkService {
  @override
  Future<VisionApiResponseDto> sendRequestAnnotateImage(
      VisionRequestDto request) async {
    try {
      final result = await getRestClient().sendRequestAnnotateImage(
        request,
        Env.apiKey,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
