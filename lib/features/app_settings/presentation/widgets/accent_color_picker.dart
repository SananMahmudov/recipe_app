import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/app_settings_cubit.dart';

class AccentColorPicker extends StatelessWidget {
  const AccentColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.watch<AppSettingsCubit>();
    final currentAccent = cubit.state.accent;

    return Row(
      children: AppColors.accentOptions.map((c) {
        final active = currentAccent.toARGB32() == c.toARGB32();
        return GestureDetector(
          onTap: () => cubit.setAccent(c),
          child: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: active
                  ? Border.all(color: colors.text, width: 2.5)
                  : null,
            ),
            child: active
                ? Icon(Icons.check, size: 18, color: cubit.state.colors.accentInk)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
