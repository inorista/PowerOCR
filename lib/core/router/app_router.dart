import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/features/home_screen/presentation/screens/home_screen.dart';
import 'package:powerocr/features/main_screen/presentation/screen/main_screen.dart';
import 'package:powerocr/features/scan_history_screen/presentation/scan_history_screen/scan_history_screen.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/scan_result_screen.dart';
import 'package:powerocr/features/scanning/presentation/screens/batch_result_screen/batch_result_screen.dart';
import 'package:powerocr/features/scanning/presentation/screens/scanning_screen/scanning_screen.dart';
import 'package:powerocr/features/splash_screen/presentation/screens/splash_screen.dart';
import 'package:powerocr/features/generate_qr/presentation/screens/generate_qr_screen.dart';
import 'package:powerocr/features/qr_library/domain/entities/user_qr.dart';
import 'package:powerocr/features/qr_library/presentation/qr_detail_screen/qr_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRouter.splash,
  routes: [
    GoRoute(
      path: AppRouter.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRouter.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRouter.scanning,
      builder: (context, state) {
        final extra = state.extra as FeatureOption;
        return ScanningScreen(featureOption: extra);
      },
    ),
    GoRoute(
      path: AppRouter.scanResult,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ScanResultScreen(
          imagePath: extra['imagePath'] as String,
          result: extra['result'] as TextRecognitionResult,
        );
      },
    ),
    GoRoute(
      path: AppRouter.scanHistory,
      builder: (context, state) => const ScanHistoryScreen(),
    ),
    GoRoute(
      path: AppRouter.batchResult,
      builder: (context, state) {
        final imagePaths = (state.extra as List<dynamic>).cast<String>();
        return BatchResultScreen(imagePaths: imagePaths);
      },
    ),
    GoRoute(
      path: AppRouter.generateQr,
      builder: (context, state) {
        return const GenerateQrScreen();
      },
    ),
    GoRoute(
      path: AppRouter.qrDetail,
      builder: (context, state) {
        final userQr = state.extra as UserQr;
        return QrDetailScreen(userQr: userQr);
      },
    ),
    GoRoute(
      path: AppRouter.main,
      builder: (context, state) {
        return const MainScreen();
      },
    ),
  ],
);

GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

class AppRouter {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String scanning = '/scanning';
  static const String scanResult = '/scan-result';
  static const String scanHistory = '/scan-history';
  static const String batchResult = '/batch-result';
  static const String generateQr = '/generate-qr';
  static const String main = '/main';
  static const String qrDetail = '/qr-detail';
}
