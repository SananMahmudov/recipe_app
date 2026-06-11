import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/models/meal.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';

class DetailControls extends StatelessWidget {
  final Meal summary;
  final Meal? fullMeal;

  const DetailControls({super.key, required this.summary, this.fullMeal});

  Future<void> _share(BuildContext context) async {
    final meal = fullMeal ?? summary;
    final url = (meal.strSource?.isNotEmpty == true)
        ? meal.strSource!
        : 'https://www.themealdb.com/meal/${meal.idMeal}';
    await Clipboard.setData(ClipboardData(text: '${meal.strMeal} — $url'));
    if (context.mounted) showAppToast(context, context.t('linkCopied'));
  }

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoritesCubit>().state.isFavorite(summary.idMeal);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _GlassBtn(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.chevron_left, size: 22, color: Colors.white),
            ),
            Row(children: [
              _GlassBtn(
                onTap: () => _share(context),
                child: const Icon(Icons.share_outlined, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              _GlassBtn(
                onTap: () => context.read<FavoritesCubit>().toggleFavorite(summary),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: isFav ? context.colors.accent : Colors.white,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _GlassBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassBtn({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.45),
        ),
        child: child,
      ),
    );
  }
}
