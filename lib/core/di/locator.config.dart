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
import 'package:powerocr/core/services/implements/local_notification_service.dart'
    as _i803;
import 'package:powerocr/core/services/implements/network_service.dart'
    as _i169;
import 'package:powerocr/core/services/implements/pdf_service.dart' as _i810;
import 'package:powerocr/core/services/implements/push_notification_service.dart'
    as _i88;
import 'package:powerocr/core/services/implements/scan_history_service.dart'
    as _i911;
import 'package:powerocr/core/services/implements/theme_setting_service.dart'
    as _i1017;
import 'package:powerocr/core/services/implements/user_qr_service.dart'
    as _i964;
import 'package:powerocr/core/services/interfaces/ilocal_notification_service.dart'
    as _i780;
import 'package:powerocr/core/services/interfaces/inetwork_service.dart'
    as _i47;
import 'package:powerocr/core/services/interfaces/ipdf_service.dart' as _i277;
import 'package:powerocr/core/services/interfaces/ipush_notification_service.dart'
    as _i455;
import 'package:powerocr/core/services/interfaces/iscan_history_service.dart'
    as _i254;
import 'package:powerocr/core/services/interfaces/itheme_setting_service.dart'
    as _i126;
import 'package:powerocr/core/services/interfaces/iuser_qr_service.dart'
    as _i973;
import 'package:powerocr/database/hive_daos/scan_history_dao.dart' as _i812;
import 'package:powerocr/database/hive_daos/scan_text_block_history_dao.dart'
    as _i1031;
import 'package:powerocr/database/hive_daos/user_qr_dao.dart' as _i118;
import 'package:powerocr/features/home_screen/data/datasources/home_local_data_source.dart'
    as _i577;
import 'package:powerocr/features/home_screen/data/repositories/home_repository_impl.dart'
    as _i576;
import 'package:powerocr/features/home_screen/domain/repositories/home_repository.dart'
    as _i729;
import 'package:powerocr/features/home_screen/domain/usecases/get_scan_history.dart'
    as _i445;
import 'package:powerocr/features/qr_library/data/datasource/qr_library_local_datasource.dart'
    as _i326;
import 'package:powerocr/features/qr_library/data/repositories/qr_library_repository_impl.dart'
    as _i977;
import 'package:powerocr/features/qr_library/domain/repositories/qr_library_repository.dart'
    as _i554;
import 'package:powerocr/features/qr_library/domain/usecases/delete_user_qr.dart'
    as _i968;
import 'package:powerocr/features/qr_library/domain/usecases/get_user_qrs.dart'
    as _i33;
import 'package:powerocr/features/qr_library/domain/usecases/save_user_qr.dart'
    as _i461;
import 'package:powerocr/features/scan_history_screen/data/datasource/scan_history_screen_data_source.dart'
    as _i290;
import 'package:powerocr/features/scan_history_screen/data/repositories/scan_history_screen_repository_impl.dart'
    as _i51;
import 'package:powerocr/features/scan_history_screen/domain/repositories/scan_history_screen_repository.dart'
    as _i986;
import 'package:powerocr/features/scanning/data/datasources/scanning_local_data_source.dart'
    as _i217;
import 'package:powerocr/features/scanning/data/datasources/scanning_remote_data_source.dart'
    as _i543;
import 'package:powerocr/features/scanning/data/repositories/scanning_repository_impl.dart'
    as _i581;
import 'package:powerocr/features/scanning/domain/repositories/scanning_repository.dart'
    as _i458;
import 'package:powerocr/features/scanning/domain/usecases/recognize_qr.dart'
    as _i142;
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
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i320.ScanningBloc>(() => _i320.ScanningBloc());
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i812.ScanHistoryDao>(() => _i812.ScanHistoryDao());
    gh.lazySingleton<_i1031.ScanTextBlockHistoryDao>(
      () => _i1031.ScanTextBlockHistoryDao(),
    );
    gh.lazySingleton<_i118.UserQrDao>(() => _i118.UserQrDao());
    gh.lazySingleton<_i729.HomeRepository>(() => _i576.HomeRepositoryImpl());
    gh.lazySingleton<_i126.IThemeSettingService>(
      () => _i1017.ThemeSettingService(),
    );
    gh.lazySingleton<_i455.IPushNotificationService>(
      () => _i88.PushNotificationService(),
    );
    gh.lazySingleton<_i217.ScanningLocalDataSource>(
      () => _i217.ScanningLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i290.ScanHistoryScreenDataSource>(
      () => _i290.ScanHistoryScreenDataSourceImpl(),
    );
    gh.lazySingleton<_i445.GetScanHistory>(
      () => _i445.GetScanHistory(gh<_i729.HomeRepository>()),
    );
    gh.lazySingleton<_i780.ILocalNotificationService>(
      () => _i803.LocalNotificationService(),
    );
    gh.lazySingleton<_i986.ScanHistoryScreenRepository>(
      () => _i51.ScanHistoryScreenRepositoryImpl(),
    );
    gh.lazySingleton<_i254.IScanHistoryService>(
      () => _i911.ScanHistoryService(),
    );
    gh.lazySingleton<_i973.IUserQrService>(
      () => _i964.UserQrService(gh<_i118.UserQrDao>()),
    );
    gh.lazySingleton<_i577.HomeLocalDataSource>(
      () => _i577.HomeLocalDataSourceImpl(gh<_i812.ScanHistoryDao>()),
    );
    gh.lazySingleton<_i47.INetworkService>(() => _i169.NetworkService());
    gh.lazySingleton<_i326.QrLibraryLocalDataSource>(
      () => _i326.QrLibraryLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i277.IPdfService>(() => _i810.PdfService());
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.provideVisionDio(),
      instanceName: 'VisionDio',
    );
    gh.lazySingleton<_i554.QrLibraryRepository>(
      () => _i977.QrLibraryRepositoryImpl(
        localDataSource: gh<_i326.QrLibraryLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i968.DeleteUserQr>(
      () => _i968.DeleteUserQr(gh<_i554.QrLibraryRepository>()),
    );
    gh.lazySingleton<_i33.GetUserQrs>(
      () => _i33.GetUserQrs(gh<_i554.QrLibraryRepository>()),
    );
    gh.lazySingleton<_i461.SaveUserQr>(
      () => _i461.SaveUserQr(gh<_i554.QrLibraryRepository>()),
    );
    gh.lazySingleton<_i150.RestClient>(
      () => registerModule.provideRestClient(
        gh<_i361.Dio>(instanceName: 'VisionDio'),
      ),
    );
    gh.lazySingleton<_i543.ScanningRemoteDataSource>(
      () => _i543.ScanningRemoteDataSourceImpl(gh<_i150.RestClient>()),
    );
    gh.lazySingleton<_i458.ScanningRepository>(
      () => _i581.ScanningRepositoryImpl(
        remoteDataSource: gh<_i543.ScanningRemoteDataSource>(),
        localDataSource: gh<_i217.ScanningLocalDataSource>(),
        connectivity: gh<_i895.Connectivity>(),
      ),
    );
    gh.lazySingleton<_i142.RecognizeQR>(
      () => _i142.RecognizeQR(gh<_i458.ScanningRepository>()),
    );
    gh.lazySingleton<_i418.RecognizeText>(
      () => _i418.RecognizeText(gh<_i458.ScanningRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i537.RegisterModule {}
