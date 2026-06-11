import '../../../../shared/models/meal.dart';

sealed class MealDetailState {}

class MealDetailInitial extends MealDetailState {}

class MealDetailLoading extends MealDetailState {}

class MealDetailLoaded extends MealDetailState {
  final Meal meal;
  MealDetailLoaded(this.meal);
}

class MealDetailError extends MealDetailState {}
