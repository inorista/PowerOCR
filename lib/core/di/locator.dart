import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/core/constants/api_constants.dart';
import 'package:powerocr/core/network/powerocr_rest_client.dart';
import 'package:powerocr/core/network/rest_client.dart';

import 'locator.config.dart';

final locator = GetIt.instance;
@InjectableInit()
Future<void> configureDependencies() async => locator.init();

@module
abstract class RegisterModule {
  @lazySingleton
  @Named('VisionDio')
  Dio provideVisionDio() {
    final dio = Dio();
    dio.options = BaseOptions(
      baseUrl: ApiConstants.visionBaseUrl,
      headers: {'X-Ios-Bundle-Identifier': 'com.dev.powerocr'},
    );
    return dio;
  }

  @lazySingleton
  @Named('PowerOCRDio')
  Dio providePowerOCRDio() {
    final dio = Dio();
    dio.options = BaseOptions(
      baseUrl: ApiConstants.powerOcrBaseUrl,
      contentType: 'application/json',
    );
    return dio;
  }

  @lazySingleton
  RestClient provideRestClient(@Named('VisionDio') Dio dio) => RestClient(dio);

  @lazySingleton
  PowerOCRRestClient providePowerOCRRestClient(@Named('PowerOCRDio') Dio dio) =>
      PowerOCRRestClient(dio);

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}

RestClient getRestClient() {
  return locator<RestClient>();
}
