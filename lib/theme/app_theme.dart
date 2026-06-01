import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  final bool isDark;
  final Color accent;

  const AppColors({required this.isDark, required this.accent});

  // ── Static accent palette ──────────────────────────────────
  static const Color accentGold = Color(0xFFE0A23A);
  static const Color accentTerracotta = Color(0xFFD2552F);
  static const Color accentGreen = Color(0xFF3E8C5A);
  static const List<Color> accentOptions = [
    accentGold,
    accentTerracotta,
    accentGreen,
  ];

  // ── Background / surface ───────────────────────────────────
  Color get bg =>
      isDark ? const Color(0xFF14110E) : const Color(0xFFFBF6EE);
  Color get surface =>
      isDark ? const Color(0xFF211C16) : Colors.white;
  Color get surface2 =>
      isDark ? const Color(0xFF2C2620) : const Color(0xFFF1E9DC);

  // ── Borders ────────────────────────────────────────────────
  Color get border => isDark
      ? Colors.white.withValues(alpha: 0.08)
      : const Color(0xFF28211A).withValues(alpha: 0.09);
  Color get borderStrong => isDark
      ? Colors.white.withValues(alpha: 0.18)
      : const Color(0xFF28211A).withValues(alpha: 0.2);

  // ── Text ───────────────────────────────────────────────────
  Color get text =>
      isDark ? const Color(0xFFF5EFE6) : const Color(0xFF2A211A);
  Color get textDim => isDark
      ? const Color(0xFFF5EFE6).withValues(alpha: 0.58)
      : const Color(0xFF2A211A).withValues(alpha: 0.62);
  Color get textFaint => isDark
      ? const Color(0xFFF5EFE6).withValues(alpha: 0.32)
      : const Color(0xFF2A211A).withValues(alpha: 0.4);

  // ── Special surfaces ───────────────────────────────────────
  Color get headerBg => isDark
      ? const Color(0xFF14110E).withValues(alpha: 0.92)
      : const Color(0xFFFBF6EE).withValues(alpha: 0.92);
  Color get cardShadowColor => isDark
      ? Colors.black.withValues(alpha: 0.35)
      : const Color(0xFF5A411E).withValues(alpha: 0.10);
  Color get toastBg =>
      isDark ? const Color(0xFF2C2620) : const Color(0xFF2A211A);
  Color get toastInk =>
      isDark ? const Color(0xFFF5EFE6) : const Color(0xFFFBF6EE);
  Color get detailFade =>
      isDark ? const Color(0xFF14110E) : const Color(0xFFFBF6EE);

  // ── Accent ─────────────────────────────────────────────────
  Color get accentInk {
    if (accent.toARGB32() == accentGold.toARGB32()) {
      return const Color(0xFF1C1305);
    }
    return Colors.white;
  }

  Color get accentSoft => accent.withValues(alpha: 0.16);

  Color get _accentGrad2 {
    if (accent.toARGB32() == accentGold.toARGB32()) {
      return const Color(0xFFC77F1F);
    }
    if (accent.toARGB32() == accentTerracotta.toARGB32()) {
      return const Color(0xFFB23C1C);
    }
    return const Color(0xFF2E6E45);
  }

  LinearGradient get accentGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent, _accentGrad2],
      );

  BoxShadow get cardShadow => BoxShadow(
        color: cardShadowColor,
        blurRadius: 18,
        offset: const Offset(0, 6),
      );
}

class AppTheme {
  static TextTheme _textTheme(Color color) => GoogleFonts.nunitoTextTheme(
        TextTheme(
          displayLarge: TextStyle(color: color),
          displayMedium: TextStyle(color: color),
          displaySmall: TextStyle(color: color),
          headlineLarge: TextStyle(color: color),
          headlineMedium: TextStyle(color: color),
          headlineSmall: TextStyle(color: color),
          titleLarge:
              TextStyle(color: color, fontWeight: FontWeight.w800),
          titleMedium:
              TextStyle(color: color, fontWeight: FontWeight.w700),
          titleSmall: TextStyle(color: color),
          bodyLarge: TextStyle(color: color),
          bodyMedium: TextStyle(color: color),
          bodySmall: TextStyle(color: color),
          labelLarge:
              TextStyle(color: color, fontWeight: FontWeight.w700),
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
