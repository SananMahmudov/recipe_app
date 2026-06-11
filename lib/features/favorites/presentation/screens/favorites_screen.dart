import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/app_btn.dart';
import '../../../../shared/widgets/state_view.dart';
import '../../../../shared/widgets/meal_grid.dart';
import '../cubit/favorites_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final favs = context.watch<FavoritesCubit>().state.favorites;

    return Column(
      children: [
        AppHeader(
          large: true,
          title: t('favorites'),
          sub: favs.isNotEmpty ? '${favs.length} ${t('recipes')}' : null,
        ),
        Expanded(
          child: favs.isEmpty
              ? StateView(
                  icon: Icons.favorite_border,
                  title: t('favoritesEmpty'),
                  hint: t('favoritesEmptyHint'),
                  action: AppBtn(
                    variant: AppBtnVariant.soft,
                    small: true,
                    onTap: () {},
                    child: Text(t('appName')),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: MealGrid(meals: favs),
                ),
        ),
      ],
    );
  }
}
