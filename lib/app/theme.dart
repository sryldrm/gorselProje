import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _primaryColor = Color(0xFF2F184B);
  static const Color _secondaryColor = Color(0xFF532B88);
  static const Color _tertiaryColor = Color(0xFFF6FEAE);
  static const Color _surfaceColor = Color(0xFFCECFC7);
  static const Color _textColor = Color(0xFFADA8B6);

  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Inter',
    scaffoldBackgroundColor: _surfaceColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _primaryColor,
      onPrimary: Colors.white,
      secondary: _secondaryColor,
      onSecondary: Colors.white,
      surface: _surfaceColor,
      onSurface: _textColor,
      background: Colors.white,
      onBackground: _primaryColor,
      error: Colors.red,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: _textColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    iconTheme: const IconThemeData(color: _primaryColor),
  );
}
