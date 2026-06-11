import 'package:flutter/material.dart';
import '../../../../shared/models/meal_category.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_image.dart';

class HomeCategoryCard extends StatelessWidget {
  final MealCategory category;

  const HomeCategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/list',
        arguments: {
          'title': category.strCategory,
          'type': 'category',
        },
      ),
      child: SizedBox(
        width: 104,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              url: category.strCategoryThumb,
              width: 104,
              height: 84,
              borderRadius: BorderRadius.circular(18),
            ),
            const SizedBox(height: 7),
            Text(
              category.strCategory,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
