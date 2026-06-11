import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/models/meal.dart';
import '../../features/app_settings/presentation/cubit/app_settings_cubit.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
import 'meal_card.dart';

class MealGrid extends StatelessWidget {
  final List<Meal> meals;
  final String? Function(Meal)? subLabel;

  const MealGrid({super.key, required this.meals, this.subLabel});

  @override
  Widget build(BuildContext context) {
    final density = context.watch<AppSettingsCubit>().state.density;
    final favCubit = context.read<FavoritesCubit>();

    void open(BuildContext ctx, Meal m) =>
        Navigator.pushNamed(ctx, '/detail', arguments: m);

    if (density == 'spacious') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
        child: Column(
          children: [
            for (final m in meals) ...[
              MealCard(
                meal: m,
                variant: MealCardVariant.hero,
                sub: subLabel != null ? subLabel!(m) : m.strCategory,
                onTap: () => open(context, m),
                onFavTap: () => favCubit.toggleFavorite(m),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      );
    }

    final cols = density == 'compact' ? 3 : 2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: cols == 3 ? 0.67 : 0.68,
        ),
        itemCount: meals.length,
        itemBuilder: (ctx, i) {
          final m = meals[i];
          return MealCard(
            meal: m,
            variant: MealCardVariant.grid,
            sub: subLabel != null ? subLabel!(m) : null,
            onTap: () => open(ctx, m),
            onFavTap: () => favCubit.toggleFavorite(m),
          );
        },
      ),
    );
  }
}
