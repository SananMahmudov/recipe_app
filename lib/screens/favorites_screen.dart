import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/meal_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final t = provider.t;
    final favs = provider.favorites;

    return Column(
      children: [
        AppHeader(
          large: true,
          title: t('favorites'),
          sub: favs.isNotEmpty
              ? '${favs.length} ${t('recipes')}'
              : null,
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
