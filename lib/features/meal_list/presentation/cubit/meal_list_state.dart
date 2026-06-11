import '../../../../shared/models/meal.dart';

sealed class MealListState {}

class MealListInitial extends MealListState {}

class MealListLoading extends MealListState {}

class MealListLoaded extends MealListState {
  final List<Meal> meals;
  final String title;
  final String type;

  MealListLoaded({
    required this.meals,
    required this.title,
    required this.type,
  });
}

class MealListError extends MealListState {}
