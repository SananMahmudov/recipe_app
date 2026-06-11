import '../../../../shared/models/meal.dart';
import '../../../../shared/models/meal_category.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MealCategory> categories;
  final List<String> areas;
  final List<Meal> popular;
  final bool loadingRandom;

  HomeLoaded({
    required this.categories,
    required this.areas,
    required this.popular,
    this.loadingRandom = false,
  });

  HomeLoaded copyWith({
    List<MealCategory>? categories,
    List<String>? areas,
    List<Meal>? popular,
    bool? loadingRandom,
  }) =>
      HomeLoaded(
        categories: categories ?? this.categories,
        areas: areas ?? this.areas,
        popular: popular ?? this.popular,
        loadingRandom: loadingRandom ?? this.loadingRandom,
      );
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
