import 'package:flutter/material.dart';
import '../../../../shared/models/meal.dart';
import '../../../../shared/widgets/app_spinner.dart';
import '../../../../shared/widgets/meal_grid.dart';

class HomePopularSection extends StatelessWidget {
  final List<Meal>? popular;
  final bool loading;

  const HomePopularSection({
    super.key,
    required this.popular,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading || popular == null) return const AppSpinner();
    if (popular!.isEmpty) return const SizedBox.shrink();

    return MealGrid(
      meals: popular!,
      subLabel: (m) => m.strArea,
    );
  }
}
