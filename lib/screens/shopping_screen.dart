import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  bool _building = false;

  Future<void> _buildFromFavorites() async {
    setState(() => _building = true);
    await context.read<AppProvider>().buildShoppingFromFavorites();
    if (mounted) setState(() => _building = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final colors = provider.colors;
    final t = provider.t;
    final list = provider.shopping;
    final remaining = list.where((i) => !i.checked).length;

    return Column(
      children: [
        AppHeader(
          large: true,
          title: t('shopping'),
          sub: list.isNotEmpty ? '$remaining ${t('itemsLeft')}' : null,
          trailing: list.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: colors.surface,
                        title: Text(t('clearAll'),
                            style: TextStyle(color: colors.text)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(t('prev'),
                                style:
                                    TextStyle(color: colors.textDim)),
                          ),
                          TextButton(
                            onPressed: () {
                              provider.clearShopping();
                              Navigator.pop(ctx);
                            },
                            child: Text(t('clearAll'),
                                style:
                                    TextStyle(color: colors.accent)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colors.surface2,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.delete_outline,
                        size: 18, color: colors.textDim),
                  ),
                )
              : null,
        ),
        Expanded(
          child: list.isEmpty
              ? StateView(
                  icon: Icons.shopping_bag_outlined,
                  title: t('shoppingEmpty'),
                  hint: t('shoppingEmptyHint'),
                  action: AppBtn(
                    variant: provider.favorites.isNotEmpty
                        ? AppBtnVariant.solid
                        : AppBtnVariant.soft,
                    small: true,
                    onTap: provider.favorites.isNotEmpty
                        ? _buildFromFavorites
                        : null,
                    child: _building
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.accentInk),
                          )
                        : Text(
                            provider.favorites.isNotEmpty
                                ? t('buildFromFavorites')
                                : t('appName'),
                          ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    children: [
                      if (provider.favorites.isNotEmpty) ...[
                        AppBtn(
                          variant: AppBtnVariant.soft,
                          small: true,
                          fullWidth: true,
                          onTap: _building ? null : _buildFromFavorites,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite, size: 16),
                              const SizedBox(width: 8),
                              Text(_building
                                  ? t('loading')
                                  : t('buildFromFavorites')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      ...list.map((item) => _ShoppingRow(
                            item: item,
                            colors: colors,
                            onToggle: () =>
                                provider.toggleShoppingItem(item.key),
                            onRemove: () =>
                                provider.removeShoppingItem(item.key),
                          )),
                      if (list.any((i) => i.checked)) ...[
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: provider.clearCheckedItems,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              t('clearChecked'),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textDim),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _ShoppingRow extends StatelessWidget {
  final dynamic item;
  final dynamic colors;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _ShoppingRow({
    required this.item,
    required this.colors,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final checked = item.checked as bool;
    final thumbUrl = MealAPI.ingredientThumb(item.name as String);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedOpacity(
        opacity: checked ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              // checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: checked ? colors.accent : Colors.transparent,
                  border: checked
                      ? null
                      : Border.all(
                          color: colors.borderStrong, width: 2),
                ),
                child: checked
                    ? Icon(Icons.check,
                        size: 16, color: colors.accentInk)
                    : null,
              ),
              const SizedBox(width: 13),
              // ingredient image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  thumbUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 40,
                    height: 40,
                    color: colors.surface2,
                    child: Icon(Icons.restaurant,
                        size: 18, color: colors.textFaint),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  item.name as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                    decoration:
                        checked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if ((item.measures as List).isNotEmpty)
                Text(
                  (item.measures as List<String>).join(', '),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textDim),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onRemove,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close,
                      size: 16, color: colors.textFaint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
