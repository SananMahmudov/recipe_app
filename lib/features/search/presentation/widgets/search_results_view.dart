import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_spinner.dart';
import '../../../../shared/widgets/state_view.dart';
import '../../../../shared/widgets/meal_grid.dart';
import '../cubit/search_cubit.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchCubit>().state;
    final t = context.t;

    if (state.isIdle) {
      return StateView(
        icon: Icons.search,
        title: t('tabSearch'),
        hint: t('searchPrompt'),
      );
    }

    if (state.loading) return AppSpinner(label: t('loading'));

    if (state.hasError) {
      return StateView(
        icon: Icons.warning_amber_rounded,
        title: t('errorMsg'),
      );
    }

    if (state.isEmpty) {
      return StateView(
        title: t('noResults'),
        hint: '"${state.query}"',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: MealGrid(
        meals: state.results!,
        subLabel: (m) => m.strArea,
      ),
    );
  }
}
