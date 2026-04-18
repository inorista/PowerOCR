import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/core/services/interfaces/ilocal_notification_service.dart';
import 'package:powerocr/core/services/interfaces/ipush_notification_service.dart';
import 'package:powerocr/core/theme/app_theme.dart';
import 'package:powerocr/core/theme/cubit/theme_cubit.dart';
import 'package:powerocr/database/hive_database.dart';
import 'package:powerocr/features/home_screen/domain/usecases/get_scan_history.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_bloc.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_event.dart';
import 'package:powerocr/features/localization/cubit/locale_cubit.dart';
import 'package:powerocr/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  await _initPlugin();
  await HiveDatabase().setupHiveDatabase();
  await configureDependencies();
  await locator<ILocalNotificationService>().initialize();
  await locator<ILocalNotificationService>().requestPermissions();
  await locator<IPushNotificationService>().initialize();
  runApp(const MainApp());
}

Future<void> _initPlugin() async {
  await AppTrackingTransparency.requestTrackingAuthorization();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
        BlocProvider<HomeBloc>(
          create: (_) =>
              HomeBloc(getScanHistory: locator<GetScanHistory>())
                ..add(LoadHomeData()),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return BlocSelector<ThemeCubit, ThemeState, ThemeMode>(
            selector: (state) => state.themeMode,
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'PowerOCR',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('vi'), Locale('en')],
                locale: localeState.locale,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: router,
                themeAnimationStyle: const AnimationStyle(
                  curve: Curves.easeOut,
                  duration: Duration(milliseconds: 400),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
