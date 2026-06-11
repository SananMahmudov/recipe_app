import '../../../../shared/models/meal.dart';

class FavoritesState {
  final List<Meal> favorites;

  const FavoritesState({required this.favorites});

  factory FavoritesState.initial() => const FavoritesState(favorites: []);

  FavoritesState copyWith({List<Meal>? favorites}) =>
      FavoritesState(favorites: favorites ?? this.favorites);

  bool isFavorite(String id) => favorites.any((m) => m.idMeal == id);
  int get count => favorites.length;
}
