import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';

class SearchModeSelector extends StatelessWidget {
  const SearchModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.watch<SearchCubit>();
    final mode = cubit.state.mode;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _Segment(
            label: context.t('byName'),
            active: mode == SearchMode.name,
            onTap: () => cubit.setMode(SearchMode.name),
          ),
          _Segment(
            label: context.t('byIngredient'),
            active: mode == SearchMode.ingredient,
            onTap: () => cubit.setMode(SearchMode.ingredient),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Segment({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active ? [colors.cardShadow] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: active ? colors.text : colors.textDim,
            ),
          ),
        ),
      ),
    );
  }
}
