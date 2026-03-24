import 'package:flutter/material.dart';

class AppTheme {
  static const Color scaffold = Color(0xFF111722);
  static const Color card = Color(0xFF1B2230);
  static const Color accent = Color(0xFF45C486);
  static const Color warning = Color(0xFFEE8F3B);
  static const Color mutedText = Color(0xFF9CA7BA);

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffold,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
