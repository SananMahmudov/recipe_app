import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';

class SettingsRow extends StatelessWidget {
  final String label;
  final Widget trailing;

  const SettingsRow({
    super.key,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
        ),
        trailing,
      ],
    );
  }
}
