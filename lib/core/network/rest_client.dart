import 'package:dio/dio.dart';
import 'package:powerocr/features/scanning/data/models/vision_request_dto.dart';
import 'package:retrofit/retrofit.dart';
part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/images:annotate')
  Future<dynamic> sendRequestAnnotateImage(
    @Body() VisionRequestDto request,
    @Query('key') String apiKey,
  );
}
