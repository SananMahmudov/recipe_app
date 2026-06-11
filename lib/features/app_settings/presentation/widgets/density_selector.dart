import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../cubit/app_settings_cubit.dart';

class DensitySelector extends StatelessWidget {
  const DensitySelector({super.key});

  static const _options = ['cozy', 'compact', 'spacious'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.watch<AppSettingsCubit>();
    final current = cubit.state.density;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: _options.map((d) {
          final active = current == d;
          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.setDensity(d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: active ? colors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: active ? [colors.cardShadow] : null,
                ),
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: active ? colors.text : colors.textDim,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
