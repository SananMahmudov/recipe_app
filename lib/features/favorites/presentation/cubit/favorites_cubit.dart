import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/models/meal.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final SharedPreferences _prefs;

  FavoritesCubit(this._prefs) : super(FavoritesState.initial()) {
    _load();
  }

  void _load() {
    final raw = _prefs.getStringList('favorites') ?? [];
    emit(FavoritesState(favorites: raw.map(Meal.fromJsonString).toList()));
  }

  void toggleFavorite(Meal meal) {
    final current = List<Meal>.from(state.favorites);
    if (state.isFavorite(meal.idMeal)) {
      current.removeWhere((m) => m.idMeal == meal.idMeal);
    } else {
      current.insert(
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
    emit(state.copyWith(favorites: List.unmodifiable(current)));
    _persist();
  }

  void _persist() {
    _prefs.setStringList(
        'favorites', state.favorites.map((m) => m.toJsonString()).toList());
  }
}
