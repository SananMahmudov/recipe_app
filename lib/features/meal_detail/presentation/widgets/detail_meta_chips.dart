import 'package:flutter/material.dart';
import '../../../../shared/models/meal.dart';
import '../../../../shared/extensions/context_extensions.dart';

class DetailMetaChips extends StatelessWidget {
  final Meal meal;

  const DetailMetaChips({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (meal.strCategory != null)
          _MetaChip(icon: Icons.local_fire_department, label: meal.strCategory!),
        if (meal.strArea != null)
          _MetaChip(icon: Icons.public, label: meal.strArea!),
        if (meal.ingredients.isNotEmpty)
          _MetaChip(
            icon: Icons.kitchen,
            label: '${meal.ingredients.length} ${t('ingredientsCount')}',
          ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.accent),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.text)),
        ],
      ),
    );
  }
}
