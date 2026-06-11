import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/models/meal.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../cubit/cooking_cubit.dart';
import '../widgets/cooking_top_bar.dart';
import '../widgets/cooking_step_body.dart';
import '../widgets/cooking_timer_card.dart';
import '../widgets/cooking_nav_buttons.dart';
import '../widgets/cooking_done_view.dart';

class CookingScreen extends StatelessWidget {
  final Meal meal;
  final List<String> steps;

  const CookingScreen({super.key, required this.meal, required this.steps});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CookingCubit(steps),
      child: _CookingView(meal: meal, steps: steps),
    );
  }
}

class _CookingView extends StatelessWidget {
  final Meal meal;
  final List<String> steps;

  const _CookingView({required this.meal, required this.steps});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final done = context.watch<CookingCubit>().state.done;

    if (done) return const CookingDoneView();

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            CookingTopBar(mealName: meal.strMeal, total: steps.length),
            Expanded(child: CookingStepBody(steps: steps)),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: const CookingTimerCard(),
            ),
            CookingNavButtons(total: steps.length),
          ],
        ),
      ),
    );
  }
}
