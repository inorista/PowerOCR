// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:powerocr/core/di/locator.dart' as _i537;
import 'package:powerocr/core/network/rest_client.dart' as _i150;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.provideVisionDio(),
      instanceName: 'VisionDio',
    );
    gh.lazySingleton<_i150.RestClient>(
      () => registerModule.provideRestClient(
        gh<_i361.Dio>(instanceName: 'VisionDio'),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i537.RegisterModule {}
