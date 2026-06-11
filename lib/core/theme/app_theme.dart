import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Color color) => GoogleFonts.nunitoTextTheme(
        TextTheme(
          displayLarge: TextStyle(color: color),
          displayMedium: TextStyle(color: color),
          displaySmall: TextStyle(color: color),
          headlineLarge: TextStyle(color: color),
          headlineMedium: TextStyle(color: color),
          headlineSmall: TextStyle(color: color),
          titleLarge: TextStyle(color: color, fontWeight: FontWeight.w800),
          titleMedium: TextStyle(color: color, fontWeight: FontWeight.w700),
          titleSmall: TextStyle(color: color),
          bodyLarge: TextStyle(color: color),
          bodyMedium: TextStyle(color: color),
          bodySmall: TextStyle(color: color),
          labelLarge: TextStyle(color: color, fontWeight: FontWeight.w700),
          labelMedium: TextStyle(color: color),
          labelSmall: TextStyle(color: color),
        ),
      );

  static ThemeData light(Color accent) {
    const bg = Color(0xFFFBF6EE);
    const text = Color(0xFF2A211A);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.light(
        primary: accent,
        surface: Colors.white,
        onSurface: text,
      ),
      textTheme: _textTheme(text),
      fontFamily: GoogleFonts.nunito().fontFamily,
    );
  }

  static ThemeData dark(Color accent) {
    const bg = Color(0xFF14110E);
    const text = Color(0xFFF5EFE6);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.dark(
        primary: accent,
        surface: const Color(0xFF211C16),
        onSurface: text,
      ),
      textTheme: _textTheme(text),
      fontFamily: GoogleFonts.nunito().fontFamily,
    );
  }
}
