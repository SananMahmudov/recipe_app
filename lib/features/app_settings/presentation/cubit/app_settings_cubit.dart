import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final SharedPreferences _prefs;

  AppSettingsCubit(this._prefs) : super(_loadFromPrefs(_prefs));

  static AppSettingsState _loadFromPrefs(SharedPreferences p) {
    final accentVal = p.getInt('accent');
    return AppSettingsState(
      isDark: p.getBool('dark') ?? true,
      accent: accentVal != null ? Color(accentVal) : const Color(0xFFE0A23A),
      lang: p.getString('lang') ?? 'az',
      density: p.getString('density') ?? 'cozy',
    );
  }

  void toggleDark() {
    emit(state.copyWith(isDark: !state.isDark));
    _persist();
  }

  void setAccent(Color c) {
    emit(state.copyWith(accent: c));
    _persist();
  }

  void setDensity(String d) {
    emit(state.copyWith(density: d));
    _persist();
  }

  void toggleLang() {
    emit(state.copyWith(lang: state.lang == 'az' ? 'en' : 'az'));
    _persist();
  }

  void _persist() {
    _prefs.setBool('dark', state.isDark);
    _prefs.setString('lang', state.lang);
    _prefs.setString('density', state.density);
    _prefs.setInt('accent', state.accent.toARGB32());
  }
}
