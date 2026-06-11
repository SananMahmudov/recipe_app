import 'package:flutter/material.dart';
import '../../../../shared/models/meal_category.dart';
import '../../../../shared/widgets/app_spinner.dart';
import 'home_category_card.dart';

class HomeCategoryList extends StatelessWidget {
  final List<MealCategory>? categories;
  final bool loading;

  const HomeCategoryList({
    super.key,
    required this.categories,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading || categories == null) return const AppSpinner();

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
        itemCount: categories!.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => HomeCategoryCard(category: categories![i]),
      ),
    );
  }
}
