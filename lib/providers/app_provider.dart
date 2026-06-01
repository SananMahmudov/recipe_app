import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../l10n/strings.dart';
import '../api/api_service.dart';

class AppProvider extends ChangeNotifier {
  bool _isDark = true;
  Color _accent = AppColors.accentGold;
  String _lang = 'az';
  String _density = 'cozy'; // cozy | compact | spacious
  List<Meal> _favorites = [];
  List<ShoppingItem> _shopping = [];

  SharedPreferences? _prefs;

  // ── Getters ────────────────────────────────────────────────
  bool get isDark => _isDark;
  Color get accent => _accent;
  String get lang => _lang;
  String get density => _density;
  List<Meal> get favorites => List.unmodifiable(_favorites);
  List<ShoppingItem> get shopping => List.unmodifiable(_shopping);
  AppColors get colors => AppColors(isDark: _isDark, accent: _accent);
  String t(String key) => AppStrings.t(key, _lang);

  int get shoppingUncheckedCount => _shopping.where((i) => !i.checked).length;

  // ── Init (call once at startup) ────────────────────────────
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDark = _prefs!.getBool('dark') ?? true;
    _lang = _prefs!.getString('lang') ?? 'az';
    _density = _prefs!.getString('density') ?? 'cozy';

    final accentVal = _prefs!.getInt('accent');
    if (accentVal != null) {
      _accent = Color(accentVal);
    }

    final favsRaw = _prefs!.getStringList('favorites') ?? [];
    _favorites = favsRaw.map(Meal.fromJsonString).toList();

    final shopRaw = _prefs!.getStringList('shopping') ?? [];
    _shopping = shopRaw.map(ShoppingItem.fromJsonString).toList();
  }

  void _persist() {
    _prefs?.setBool('dark', _isDark);
    _prefs?.setString('lang', _lang);
    _prefs?.setString('density', _density);
    _prefs?.setInt('accent', _accent.toARGB32());
    _prefs?.setStringList(
        'favorites', _favorites.map((m) => m.toJsonString()).toList());
    _prefs?.setStringList(
        'shopping', _shopping.map((i) => i.toJsonString()).toList());
  }

  // ── Theme / appearance ─────────────────────────────────────
  void toggleDark() {
    _isDark = !_isDark;
    notifyListeners();
    _persist();
  }

  void setAccent(Color c) {
    _accent = c;
    notifyListeners();
    _persist();
  }

  void setDensity(String d) {
    _density = d;
    notifyListeners();
    _persist();
  }

  // ── Language ───────────────────────────────────────────────
  void toggleLang() {
    _lang = _lang == 'az' ? 'en' : 'az';
    notifyListeners();
    _persist();
  }

  // ── Favorites ──────────────────────────────────────────────
  bool isFavorite(String id) => _favorites.any((m) => m.idMeal == id);

  void toggleFavorite(Meal meal) {
    if (isFavorite(meal.idMeal)) {
      _favorites.removeWhere((m) => m.idMeal == meal.idMeal);
    } else {
      _favorites.insert(
        0,
        Meal(
          idMeal: meal.idMeal,
          strMeal: meal.strMeal,
          strMealThumb: meal.strMealThumb,
          strCategory: meal.strCategory,
          strArea: meal.strArea,
        ),
      );
    }
    notifyListeners();
    _persist();
  }

  // ── Shopping list ──────────────────────────────────────────
  bool inShoppingList(String name) =>
      _shopping.any((i) => i.key == name.trim().toLowerCase());

  void addIngredients(List<MealIngredient> items) {
    final map = <String, ShoppingItem>{
      for (final i in _shopping) i.key: i,
    };
    for (final item in items) {
      final key = item.ingredient.trim().toLowerCase();
      if (!map.containsKey(key)) {
        map[key] = ShoppingItem(
          key: key,
          name: item.ingredient,
          measures: item.measure.isNotEmpty ? [item.measure] : [],
        );
      } else {
        final existing = map[key]!;
        if (item.measure.isNotEmpty &&
            !existing.measures.contains(item.measure)) {
          map[key] = existing.copyWith(
              measures: [...existing.measures, item.measure]);
        }
      }
    }
    _shopping = map.values.toList();
    notifyListeners();
    _persist();
  }

  void toggleShoppingItem(String key) {
    final idx = _shopping.indexWhere((i) => i.key == key);
    if (idx >= 0) {
      _shopping[idx] = _shopping[idx].copyWith(checked: !_shopping[idx].checked);
      notifyListeners();
      _persist();
    }
  }

  void removeShoppingItem(String key) {
    _shopping.removeWhere((i) => i.key == key);
    notifyListeners();
    _persist();
  }

  void clearCheckedItems() {
    _shopping.removeWhere((i) => i.checked);
    notifyListeners();
    _persist();
  }

  void clearShopping() {
    _shopping.clear();
    notifyListeners();
    _persist();
  }

  Future<void> buildShoppingFromFavorites() async {
    final all = <MealIngredient>[];
    for (final fav in _favorites) {
      try {
        final full = await MealAPI.lookup(fav.idMeal);
        if (full != null) all.addAll(full.ingredients);
      } catch (_) {}
    }
    if (all.isNotEmpty) addIngredients(all);
  }
}
