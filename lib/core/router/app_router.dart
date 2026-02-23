import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/features/home/presentation/screens/home_screen.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen.dart';
import 'package:powerocr/features/scanning/presentation/screens/scanning_screen.dart';
import 'package:powerocr/features/splash/presentation/screens/splash_screen.dart';

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
      builder: (context, state) => const ScanningScreen(),
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
  ],
);

GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

class AppRouter {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String scanning = '/scanning';
  static const String scanResult = '/scan-result';
}
