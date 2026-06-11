import 'package:flutter/material.dart';
import '../../../../shared/models/meal.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../core/network/meal_api_client.dart';

class DetailIngredientRow extends StatelessWidget {
  final MealIngredient ingredient;
  final bool inList;
  final VoidCallback onTap;

  const DetailIngredientRow({
    super.key,
    required this.ingredient,
    required this.inList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                MealApiClient.ingredientThumb(ingredient.ingredient),
                width: 42, height: 42, fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 42, height: 42, color: colors.surface2,
                  child: Icon(Icons.kitchen, size: 18, color: colors.textFaint),
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(ingredient.ingredient,
                  style: TextStyle(
                      fontSize: 15.5, fontWeight: FontWeight.w600, color: colors.text)),
            ),
            if (ingredient.measure.isNotEmpty)
              Text(ingredient.measure,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: colors.textDim)),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 26, height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: inList ? colors.accent : colors.surface2,
              ),
              child: Icon(inList ? Icons.check : Icons.add,
                  size: 15, color: inList ? colors.accentInk : colors.textDim),
            ),
          ],
        ),
      ),
    );
  }
}
