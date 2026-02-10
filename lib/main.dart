import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/core/theme/app_theme.dart';
import 'package:powerocr/core/theme/cubit/theme_cubit.dart';
import 'package:powerocr/database/hive_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase().setupHiveDatabase();
  await configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'PowerOCR',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
