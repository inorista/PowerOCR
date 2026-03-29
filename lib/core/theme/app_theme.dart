import 'package:flutter/material.dart';

class AppTheme {
  static const _lightPrimary = Color(0xFF8B8FE3);
  static const _lightSecondary = Color(0xFF95E1D3);
  static const _lightBackground = Color(0xFFF9FAFD);
  static const _lightSurface = Colors.white;
  static const _lightError = Color(0xFFE57373);

  static const _darkPrimary = Color.fromARGB(255, 203, 205, 236);
  static const _darkSecondary = Color(0xFF80CBC4);
  static const _darkBackground = Color(0xFF23232F);
  static const _darkSurface = Color(0xFF2E2E3E);
  static const _darkError = Color(0xFFEF9A9A);

  static final ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    primary: _lightPrimary,
    secondary: _lightSecondary,
    background: _lightBackground,
    surface: _lightSurface,
    error: _lightError,
    onSurface: Colors.black87,
  );

  static final ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    primary: _darkPrimary,
    secondary: _darkSecondary,
    background: _darkBackground,
    surface: _darkSurface,
    error: _darkError,
    onSurface: const Color(0xFFE0E0E0),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color error,
    required Color onSurface,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onSurface: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF1A1A24),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF1A1A24),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? Colors.grey.shade100
            : Colors.white.withValues(alpha: 0.05),
        hintStyle: TextStyle(color: onSurface.withValues(alpha: 0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      iconTheme: IconThemeData(color: onSurface),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        displayMedium: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        displaySmall: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        headlineLarge: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        headlineMedium: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        headlineSmall: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        titleLarge: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        titleMedium: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        titleSmall: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        bodyLarge: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        bodyMedium: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        bodySmall: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        labelLarge: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        labelMedium: TextStyle(fontFamily: 'Montserrat', color: onSurface),
        labelSmall: TextStyle(fontFamily: 'Montserrat', color: onSurface),
      ),
    );
  }
}
