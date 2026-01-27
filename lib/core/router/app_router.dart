import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/features/home/presentation/screens/home_screen.dart';
import 'package:powerocr/features/scanning/presentation/screens/scanning_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRouter.home,
  routes: [
    GoRoute(
      path: AppRouter.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppRouter.scanning,
      builder: (context, state) {
        return const ScanningScreen();
      },
    ),
  ],
);

GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

class AppRouter {
  static String home = '/home';
  static String scanning = '/scanning';
}
