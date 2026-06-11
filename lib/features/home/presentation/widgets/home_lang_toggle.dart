import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../app_settings/presentation/cubit/app_settings_cubit.dart';

class HomeLangToggle extends StatelessWidget {
  const HomeLangToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.watch<AppSettingsCubit>();

    return GestureDetector(
      onTap: cubit.toggleLang,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.public, size: 16, color: colors.text),
            const SizedBox(width: 6),
            Text(
              cubit.state.lang.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
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
