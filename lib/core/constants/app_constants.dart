import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  static const double paddingXs = 4;
  static const double paddingS = 8;
  static const double paddingM = 12;
  static const double paddingL = 16;
  static const double paddingXl = 20;
  static const double paddingXxl = 24;

  static const double radiusS = 10;
  static const double radiusM = 14;
  static const double radiusL = 18;
  static const double radiusXl = 20;
  static const double radiusXxl = 26;
  static const double radiusFull = 999;

  static const double iconSizeS = 15;
  static const double iconSizeM = 18;
  static const double iconSizeL = 20;
  static const double iconSizeXl = 24;

  static const double circleButtonSize = 38;
  static const double bottomNavHeight = 64;
  static const double categoryCardWidth = 104;
  static const double categoryCardHeight = 84;
  static const double categoryListHeight = 120;
  static const double cuisineListHeight = 46;
  static const double heroImageHeight = 320;
}

class AppDurations {
  AppDurations._();

  static const Duration press = Duration(milliseconds: 80);
  static const Duration animate = Duration(milliseconds: 150);
  static const Duration progress = Duration(milliseconds: 250);
  static const Duration debounce = Duration(milliseconds: 420);
  static const Duration toast = Duration(milliseconds: 1900);
}

class AppColorConstants {
  AppColorConstants._();

  static const Color darkBg = Color(0xFF14110E);
  static const Color darkSurface = Color(0xFF211C16);
  static const Color darkSurface2 = Color(0xFF2C2620);
  static const Color darkText = Color(0xFFF5EFE6);

  static const Color lightBg = Color(0xFFFBF6EE);
  static const Color lightSurface = Colors.white;
  static const Color lightSurface2 = Color(0xFFF1E9DC);
  static const Color lightText = Color(0xFF2A211A);

  static const Color accentGold = Color(0xFFE0A23A);
  static const Color accentTerracotta = Color(0xFFD2552F);
  static const Color accentGreen = Color(0xFF3E8C5A);

  static const List<Color> accentOptions = [
    accentGold,
    accentTerracotta,
    accentGreen,
  ];
}
