import 'package:dio/dio.dart';
import 'package:powerocr/features/scanning/data/models/health_check_dto.dart';
import 'package:powerocr/features/scanning/data/models/powerocr_request_dto.dart';
import 'package:powerocr/features/scanning/data/models/powerocr_response_dto.dart';
import 'package:retrofit/retrofit.dart';
part 'powerocr_rest_client.g.dart';

@RestApi()
abstract class PowerOCRRestClient {
  factory PowerOCRRestClient(Dio dio, {String baseUrl}) = _PowerOCRRestClient;

  @GET('/api/v1/health')
  Future<HealthCheckDto> healthCheck();

  @POST('/api/v1/scan-base64')
  Future<PowerOCRResponseDto> scanBase64(@Body() PowerOCRRequestDto request);
}
