import 'package:flutter/material.dart';
import '../../../../shared/models/shopping_item.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../core/network/meal_api_client.dart';

class ShoppingRow extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const ShoppingRow({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final thumbUrl = MealApiClient.ingredientThumb(item.name);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedOpacity(
        opacity: item.checked ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26, height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: item.checked ? colors.accent : Colors.transparent,
                  border: item.checked
                      ? null
                      : Border.all(color: colors.borderStrong, width: 2),
                ),
                child: item.checked
                    ? Icon(Icons.check, size: 16, color: colors.accentInk)
                    : null,
              ),
              const SizedBox(width: 13),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  thumbUrl,
                  width: 40, height: 40, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 40, height: 40, color: colors.surface2,
                    child: Icon(Icons.restaurant, size: 18, color: colors.textFaint),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: colors.text,
                    decoration: item.checked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (item.measures.isNotEmpty)
                Text(
                  item.measures.join(', '),
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textDim),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onRemove,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 16, color: colors.textFaint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
