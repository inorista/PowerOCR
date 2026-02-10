// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:powerocr/core/di/locator.dart' as _i537;
import 'package:powerocr/core/network/rest_client.dart' as _i150;
import 'package:powerocr/core/services/implements/network_service.dart'
    as _i169;
import 'package:powerocr/core/services/implements/theme_setting_service.dart'
    as _i1017;
import 'package:powerocr/core/services/interfaces/inetwork_service.dart'
    as _i47;
import 'package:powerocr/core/services/interfaces/itheme_setting_service.dart'
    as _i126;
import 'package:powerocr/database/hive_daos/theme_setting_dao.dart' as _i406;
import 'package:powerocr/features/scanning/data/datasources/scanning_local_data_source.dart'
    as _i217;
import 'package:powerocr/features/scanning/data/datasources/scanning_remote_data_source.dart'
    as _i543;
import 'package:powerocr/features/scanning/data/repositories/scanning_repository_impl.dart'
    as _i581;
import 'package:powerocr/features/scanning/domain/repositories/scanning_repository.dart'
    as _i458;
import 'package:powerocr/features/scanning/domain/usecases/recognize_text.dart'
    as _i418;
import 'package:powerocr/features/scanning/presentation/bloc/scanning_bloc.dart'
    as _i320;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i320.ScanningBloc>(() => _i320.ScanningBloc());
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i406.ThemeSettingDao>(() => _i406.ThemeSettingDao());
    gh.lazySingleton<_i126.IThemeSettingService>(
        () => _i1017.ThemeSettingService(gh<_i406.ThemeSettingDao>()));
    gh.lazySingleton<_i217.ScanningLocalDataSource>(
        () => _i217.ScanningLocalDataSourceImpl());
    gh.lazySingleton<_i47.INetworkService>(() => _i169.NetworkService());
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.provideVisionDio(),
      instanceName: 'VisionDio',
    );
    gh.lazySingleton<_i150.RestClient>(() => registerModule
        .provideRestClient(gh<_i361.Dio>(instanceName: 'VisionDio')));
    gh.lazySingleton<_i543.ScanningRemoteDataSource>(
        () => _i543.ScanningRemoteDataSourceImpl(gh<_i150.RestClient>()));
    gh.lazySingleton<_i458.ScanningRepository>(
        () => _i581.ScanningRepositoryImpl(
              remoteDataSource: gh<_i543.ScanningRemoteDataSource>(),
              localDataSource: gh<_i217.ScanningLocalDataSource>(),
              connectivity: gh<_i895.Connectivity>(),
            ));
    gh.lazySingleton<_i418.RecognizeText>(
        () => _i418.RecognizeText(gh<_i458.ScanningRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i537.RegisterModule {}
