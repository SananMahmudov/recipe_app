import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/models/meal.dart';
import '../../shared/extensions/context_extensions.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
import 'app_image.dart';
import 'heart_btn.dart';

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
    final colors = context.colors;
    final isFav = context.watch<FavoritesCubit>().state.isFavorite(meal.idMeal);
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

class _HeroCard extends StatelessWidget {
  final Meal meal;
  final dynamic colors;
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
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.48, 0.75, 1.0],
                      colors: [
                        Colors.transparent, Colors.transparent,
                        Colors.black.withValues(alpha: 0.18),
                        Colors.black.withValues(alpha: 0.78),
                      ],
                    ),
                  ),
                ),
              ),
              if (onFavTap != null)
                Positioned(top: 12, right: 12,
                    child: HeartBtn(active: isFav, onTap: onFavTap!, floating: true)),
              Positioned(
                left: 16, right: 16, bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sub != null) ...[
                      Text(sub!, style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w700,
                          color: Color(0xD9FFFFFF), letterSpacing: 0.8)),
                      const SizedBox(height: 4),
                    ],
                    Text(meal.strMeal, style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800,
                        color: Colors.white, height: 1.15)),
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

class _GridCard extends StatelessWidget {
  final Meal meal;
  final dynamic colors;
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
                AspectRatio(aspectRatio: 1, child: AppImage(url: meal.strMealThumb)),
                if (onFavTap != null)
                  Positioned(top: 8, right: 8,
                      child: HeartBtn(active: isFav, onTap: onFavTap!, size: 32, floating: true)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.strMeal,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w700,
                          color: colors.text, height: 1.25)),
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(sub!, style: TextStyle(fontSize: 12.5, color: colors.textDim)),
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

class _RowCard extends StatelessWidget {
  final Meal meal;
  final dynamic colors;
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
        decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            AppImage(url: meal.strMealThumb, width: 64, height: 64,
                borderRadius: BorderRadius.circular(14)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.strMeal,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: colors.text)),
                  if (sub != null)
                    Text(sub!, style: TextStyle(fontSize: 13, color: colors.textDim)),
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
