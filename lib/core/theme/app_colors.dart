import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppColors {
  final bool isDark;
  final Color accent;

  const AppColors({required this.isDark, required this.accent});

  static const Color accentGold = AppColorConstants.accentGold;
  static const Color accentTerracotta = AppColorConstants.accentTerracotta;
  static const Color accentGreen = AppColorConstants.accentGreen;
  static const List<Color> accentOptions = AppColorConstants.accentOptions;

  Color get bg =>
      isDark ? AppColorConstants.darkBg : AppColorConstants.lightBg;
  Color get surface =>
      isDark ? AppColorConstants.darkSurface : AppColorConstants.lightSurface;
  Color get surface2 =>
      isDark ? AppColorConstants.darkSurface2 : AppColorConstants.lightSurface2;

  Color get border => isDark
      ? Colors.white.withValues(alpha: 0.08)
      : const Color(0xFF28211A).withValues(alpha: 0.09);
  Color get borderStrong => isDark
      ? Colors.white.withValues(alpha: 0.18)
      : const Color(0xFF28211A).withValues(alpha: 0.2);

  Color get text =>
      isDark ? AppColorConstants.darkText : AppColorConstants.lightText;
  Color get textDim => isDark
      ? AppColorConstants.darkText.withValues(alpha: 0.58)
      : AppColorConstants.lightText.withValues(alpha: 0.62);
  Color get textFaint => isDark
      ? AppColorConstants.darkText.withValues(alpha: 0.32)
      : AppColorConstants.lightText.withValues(alpha: 0.4);

  Color get headerBg => isDark
      ? AppColorConstants.darkBg.withValues(alpha: 0.92)
      : AppColorConstants.lightBg.withValues(alpha: 0.92);
  Color get cardShadowColor => isDark
      ? Colors.black.withValues(alpha: 0.35)
      : const Color(0xFF5A411E).withValues(alpha: 0.10);
  Color get toastBg =>
      isDark ? AppColorConstants.darkSurface2 : AppColorConstants.lightText;
  Color get toastInk =>
      isDark ? AppColorConstants.darkText : AppColorConstants.lightBg;
  Color get detailFade =>
      isDark ? AppColorConstants.darkBg : AppColorConstants.lightBg;

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
