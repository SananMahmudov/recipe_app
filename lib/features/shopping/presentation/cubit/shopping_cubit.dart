import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/models/meal.dart';
import '../../../../shared/models/shopping_item.dart';
import '../../../../core/network/meal_api_client.dart';
import 'shopping_state.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  final SharedPreferences _prefs;
  final MealApiClient _api;

  ShoppingCubit(this._prefs, this._api) : super(ShoppingState.initial()) {
    _load();
  }

  void _load() {
    final raw = _prefs.getStringList('shopping') ?? [];
    emit(ShoppingState(
      items: List.unmodifiable(raw.map(ShoppingItem.fromJsonString).toList()),
    ));
  }

  void addIngredients(List<MealIngredient> ingredients) {
    final map = <String, ShoppingItem>{
      for (final i in state.items) i.key: i,
    };
    for (final item in ingredients) {
      final key = item.ingredient.trim().toLowerCase();
      if (!map.containsKey(key)) {
        map[key] = ShoppingItem(
          key: key,
          name: item.ingredient,
          measures: item.measure.isNotEmpty ? [item.measure] : [],
        );
      } else {
        final existing = map[key]!;
        if (item.measure.isNotEmpty && !existing.measures.contains(item.measure)) {
          map[key] = existing.copyWith(measures: [...existing.measures, item.measure]);
        }
      }
    }
    emit(state.copyWith(items: List.unmodifiable(map.values.toList())));
    _persist();
  }

  bool inList(String name) =>
      state.items.any((i) => i.key == name.trim().toLowerCase());

  void toggleItem(String key) {
    final updated = state.items.map((i) {
      return i.key == key ? i.copyWith(checked: !i.checked) : i;
    }).toList();
    emit(state.copyWith(items: List.unmodifiable(updated)));
    _persist();
  }

  void removeItem(String key) {
    emit(state.copyWith(
        items: List.unmodifiable(state.items.where((i) => i.key != key).toList())));
    _persist();
  }

  void clearChecked() {
    emit(state.copyWith(
        items: List.unmodifiable(state.items.where((i) => !i.checked).toList())));
    _persist();
  }

  void clearAll() {
    emit(state.copyWith(items: List.unmodifiable(const [])));
    _persist();
  }

  Future<void> buildFromFavorites(List<Meal> favorites) async {
    emit(state.copyWith(buildingFromFavorites: true));
    final all = <MealIngredient>[];
    for (final fav in favorites) {
      try {
        final full = await _api.lookup(fav.idMeal);
        if (full != null) all.addAll(full.ingredients);
      } catch (_) {}
    }
    if (all.isNotEmpty) addIngredients(all);
    emit(state.copyWith(buildingFromFavorites: false));
  }

  void _persist() {
    _prefs.setStringList(
        'shopping', state.items.map((i) => i.toJsonString()).toList());
  }
}
