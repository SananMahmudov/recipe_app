import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../cubit/app_settings_cubit.dart';
import '../widgets/settings_row.dart';
import '../widgets/accent_color_picker.dart';
import '../widgets/density_selector.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.watch<AppSettingsCubit>();
    final t = cubit.state.t;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            t('settings'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 20),
          SettingsRow(
            label: t('darkMode'),
            trailing: Switch(
              value: cubit.state.isDark,
              onChanged: (_) => cubit.toggleDark(),
              activeThumbColor: colors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            t('accentColor'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colors.textDim,
            ),
          ),
          const SizedBox(height: 10),
          const AccentColorPicker(),
          const SizedBox(height: 20),
          Text(
            t('density'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colors.textDim,
            ),
          ),
          const SizedBox(height: 10),
          const DensitySelector(),
        ],
      ),
    );
  }
}
