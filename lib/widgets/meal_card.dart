import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

enum MealCardVariant { grid, hero, row }

class MealCard extends StatelessWidget {
  final Meal meal;
  final MealCardVariant variant;
  final VoidCallback onTap;
  final VoidCallback? onFavTap;
  final String? sub;

  const MealCard({
    super.key,
    required this.meal,
    this.variant = MealCardVariant.grid,
    required this.onTap,
    this.onFavTap,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppProvider>().colors;
    final isFav = context.watch<AppProvider>().isFavorite(meal.idMeal);

    return switch (variant) {
      MealCardVariant.hero => _HeroCard(
          meal: meal, colors: colors, isFav: isFav,
          onTap: onTap, onFavTap: onFavTap, sub: sub),
      MealCardVariant.grid => _GridCard(
          meal: meal, colors: colors, isFav: isFav,
          onTap: onTap, onFavTap: onFavTap, sub: sub),
      MealCardVariant.row => _RowCard(
          meal: meal, colors: colors, isFav: isFav,
          onTap: onTap, onFavTap: onFavTap, sub: sub),
    };
  }
}

// ── Hero card (full-width, 16:10, title overlaid) ─────────────
class _HeroCard extends StatelessWidget {
  final Meal meal;
  final AppColors colors;
  final bool isFav;
  final VoidCallback onTap;
  final VoidCallback? onFavTap;
  final String? sub;

  const _HeroCard({
    required this.meal, required this.colors, required this.isFav,
    required this.onTap, this.onFavTap, this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [colors.cardShadow],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: AppImage(url: meal.strMealThumb),
              ),
              // gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.48, 0.75, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.18),
                        Colors.black.withValues(alpha: 0.78),
                      ],
                    ),
                  ),
                ),
              ),
              // fav button
              if (onFavTap != null)
                Positioned(
                  top: 12, right: 12,
                  child: HeartBtn(
                    active: isFav, onTap: onFavTap!, floating: true),
                ),
              // title
              Positioned(
                left: 16, right: 16, bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sub != null)
                      Text(sub!,
                          style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xD9FFFFFF),
                              letterSpacing: 0.8)),
                    if (sub != null) const SizedBox(height: 4),
                    Text(
                      meal.strMeal,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Grid card (square thumb + title below) ────────────────────
class _GridCard extends StatelessWidget {
  final Meal meal;
  final AppColors colors;
  final bool isFav;
  final VoidCallback onTap;
  final VoidCallback? onFavTap;
  final String? sub;

  const _GridCard({
    required this.meal, required this.colors, required this.isFav,
    required this.onTap, this.onFavTap, this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [colors.cardShadow],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: AppImage(url: meal.strMealThumb),
                ),
                if (onFavTap != null)
                  Positioned(
                    top: 8, right: 8,
                    child: HeartBtn(
                        active: isFav, onTap: onFavTap!,
                        size: 32, floating: true),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.strMeal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                        height: 1.25),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(sub!,
                        style: TextStyle(
                            fontSize: 12.5, color: colors.textDim)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Row card (thumb + text inline) ───────────────────────────
class _RowCard extends StatelessWidget {
  final Meal meal;
  final AppColors colors;
  final bool isFav;
  final VoidCallback onTap;
  final VoidCallback? onFavTap;
  final String? sub;

  const _RowCard({
    required this.meal, required this.colors, required this.isFav,
    required this.onTap, this.onFavTap, this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            AppImage(
              url: meal.strMealThumb,
              width: 64,
              height: 64,
              borderRadius: BorderRadius.circular(14),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.strMeal,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.text),
                  ),
                  if (sub != null)
                    Text(sub!,
                        style: TextStyle(
                            fontSize: 13, color: colors.textDim)),
                ],
              ),
            ),
            if (onFavTap != null)
              HeartBtn(active: isFav, onTap: onFavTap!, size: 34),
          ],
        ),
      ),
    );
  }
}

// ── Meal grid (handles density variants) ─────────────────────
class MealGrid extends StatelessWidget {
  final List<Meal> meals;
  final String? Function(Meal)? subLabel;

  const MealGrid({super.key, required this.meals, this.subLabel});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final density = provider.density;

    void open(BuildContext ctx, Meal m) =>
        Navigator.pushNamed(ctx, '/detail', arguments: m);
    void fav(Meal m) => provider.toggleFavorite(m);

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
                onFavTap: () => fav(m),
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
            onFavTap: () => fav(m),
          );
        },
      ),
    );
  }
}
