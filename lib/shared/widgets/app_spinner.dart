import 'package:flutter/material.dart';
import '../../shared/extensions/context_extensions.dart';

class AppSpinner extends StatelessWidget {
  final String? label;

  const AppSpinner({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colors.accent,
              backgroundColor: colors.border,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 14),
            Text(
              label!,
              style: TextStyle(fontSize: 14, color: colors.textDim),
            ),
          ],
        ],
      ),
    );
  }
}
