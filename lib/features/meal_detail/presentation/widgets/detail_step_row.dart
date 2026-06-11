import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';

class DetailStepRow extends StatelessWidget {
  final int number;
  final String text;

  const DetailStepRow({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26, height: 26,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(shape: BoxShape.circle, color: colors.accentSoft),
            child: Center(
              child: Text('$number',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w800, color: colors.accent)),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 15.5, height: 1.6,
                    color: colors.text.withValues(alpha: 0.92))),
          ),
        ],
      ),
    );
  }
}
