import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/models/meal.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/app_btn.dart';
import '../../../../shared/widgets/state_view.dart';
import '../cubit/shopping_cubit.dart';
import '../cubit/shopping_state.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../widgets/shopping_row.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final shopping = context.watch<ShoppingCubit>();
    final state = shopping.state;
    final favs = context.watch<FavoritesCubit>().state.favorites;

    return Column(
      children: [
        AppHeader(
          large: true,
          title: t('shopping'),
          sub: !state.isEmpty ? '${state.uncheckedCount} ${t('itemsLeft')}' : null,
          trailing: !state.isEmpty ? _clearAllBtn(context, colors, shopping, t) : null,
        ),
        Expanded(
          child: state.isEmpty
              ? _emptyState(context, t, colors, shopping, favs, state.buildingFromFavorites)
              : _listContent(context, t, colors, shopping, favs, state),
        ),
      ],
    );
  }

  Widget _clearAllBtn(BuildContext context, dynamic colors, ShoppingCubit cubit,
      String Function(String) t) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: colors.surface,
          title: Text(t('clearAll'), style: TextStyle(color: colors.text)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('prev'), style: TextStyle(color: colors.textDim)),
            ),
            TextButton(
              onPressed: () { cubit.clearAll(); Navigator.pop(ctx); },
              child: Text(t('clearAll'), style: TextStyle(color: colors.accent)),
            ),
          ],
        ),
      ),
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: colors.surface2, shape: BoxShape.circle),
        child: Icon(Icons.delete_outline, size: 18, color: colors.textDim),
      ),
    );
  }

  Widget _emptyState(BuildContext context, String Function(String) t,
      dynamic colors, ShoppingCubit cubit, List<Meal> favs, bool building) {
    return StateView(
      icon: Icons.shopping_bag_outlined,
      title: t('shoppingEmpty'),
      hint: t('shoppingEmptyHint'),
      action: AppBtn(
        variant: favs.isNotEmpty ? AppBtnVariant.solid : AppBtnVariant.soft,
        small: true,
        onTap: favs.isNotEmpty ? () => cubit.buildFromFavorites(favs) : null,
        child: building
            ? SizedBox(width: 16, height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: colors.accentInk))
            : Text(favs.isNotEmpty ? t('buildFromFavorites') : t('appName')),
      ),
    );
  }

  Widget _listContent(BuildContext context, String Function(String) t,
      dynamic colors, ShoppingCubit cubit, List<Meal> favs, ShoppingState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        children: [
          if (favs.isNotEmpty) ...[
            AppBtn(
              variant: AppBtnVariant.soft,
              small: true,
              fullWidth: true,
              onTap: state.buildingFromFavorites ? null : () => cubit.buildFromFavorites(favs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, size: 16),
                  const SizedBox(width: 8),
                  Text(state.buildingFromFavorites ? t('loading') : t('buildFromFavorites')),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          ...state.items.map((item) => ShoppingRow(
                item: item,
                onToggle: () => cubit.toggleItem(item.key),
                onRemove: () => cubit.removeItem(item.key),
              )),
          if (state.items.any((i) => i.checked)) ...[
            const SizedBox(height: 4),
            GestureDetector(
              onTap: cubit.clearChecked,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(t('clearChecked'),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textDim)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
