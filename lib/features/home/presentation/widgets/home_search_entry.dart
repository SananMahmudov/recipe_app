import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';

class HomeSearchEntry extends StatelessWidget {
  const HomeSearchEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return GestureDetector(
      onTap: () {
        // Switch to search tab — handled by MainScreen
        final nav = Navigator.of(context, rootNavigator: false);
        nav.pushNamed('/search');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 19, color: colors.textDim),
            const SizedBox(width: 10),
            Text(
              t('searchPlaceholder'),
              style: TextStyle(fontSize: 15, color: colors.textDim),
            ),
          ],
        ),
      ),
    );
  }
}
