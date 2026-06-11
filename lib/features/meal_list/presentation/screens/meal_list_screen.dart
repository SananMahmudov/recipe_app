import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/app_btn.dart';
import '../../../../shared/widgets/app_spinner.dart';
import '../../../../shared/widgets/state_view.dart';
import '../../../../shared/widgets/meal_grid.dart';
import '../cubit/meal_list_cubit.dart';
import '../cubit/meal_list_state.dart';

class MealListScreen extends StatefulWidget {
  final String title;
  final String type;

  const MealListScreen({super.key, required this.title, required this.type});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MealListCubit>().load(widget.title, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;
    final sub = widget.type == 'area' ? t('cuisines') : t('categories');

    return Scaffold(
      backgroundColor: colors.bg,
      body: Column(
        children: [
          AppHeader(
            title: widget.title,
            sub: sub,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: BlocBuilder<MealListCubit, MealListState>(
              builder: (context, state) {
                if (state is MealListLoading || state is MealListInitial) {
                  return AppSpinner(label: t('loading'));
                }
                if (state is MealListError) {
                  return StateView(
                    icon: Icons.warning_amber_rounded,
                    title: t('errorMsg'),
                    action: AppBtn(
                      variant: AppBtnVariant.soft,
                      small: true,
                      onTap: () => Navigator.pop(context),
                      child: Text(t('retry')),
                    ),
                  );
                }
                if (state is MealListLoaded) {
                  if (state.meals.isEmpty) {
                    return StateView(title: t('noResults'));
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Text(
                            '${state.meals.length} ${t('recipes')}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.textDim,
                            ),
                          ),
                        ),
                        MealGrid(meals: state.meals),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
