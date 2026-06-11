import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../cubit/cooking_cubit.dart';

class CookingStepBody extends StatelessWidget {
  final List<String> steps;

  const CookingStepBody({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;
    final state = context.watch<CookingCubit>().state;
    final total = steps.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${t('step')} ${state.stepIndex + 1} ${t('of')} $total',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.accent,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            steps[state.stepIndex],
            style: TextStyle(
              fontSize: 22,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}
