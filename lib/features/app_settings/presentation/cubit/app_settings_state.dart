import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/constants/app_constants.dart';

class AppSettingsState {
  final bool isDark;
  final Color accent;
  final String lang;
  final String density;

  const AppSettingsState({
    required this.isDark,
    required this.accent,
    required this.lang,
    required this.density,
  });

  factory AppSettingsState.initial() => const AppSettingsState(
        isDark: true,
        accent: AppColorConstants.accentGold,
        lang: 'az',
        density: 'cozy',
      );

  AppSettingsState copyWith({
    bool? isDark,
    Color? accent,
    String? lang,
    String? density,
  }) =>
      AppSettingsState(
        isDark: isDark ?? this.isDark,
        accent: accent ?? this.accent,
        lang: lang ?? this.lang,
        density: density ?? this.density,
      );

  AppColors get colors => AppColors(isDark: isDark, accent: accent);

  String t(String key) => AppStrings.t(key, lang);
}
