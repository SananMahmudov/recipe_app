import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/models/meal.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_btn.dart';
import '../../../../shared/widgets/app_spinner.dart';
import '../../../../shared/widgets/state_view.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../shopping/presentation/cubit/shopping_cubit.dart';
import '../cubit/meal_detail_cubit.dart';
import '../cubit/meal_detail_state.dart';
import '../widgets/detail_hero_image.dart';
import '../widgets/detail_controls.dart';
import '../widgets/detail_meta_chips.dart';
import '../widgets/detail_ingredient_row.dart';
import '../widgets/detail_step_row.dart';
import '../widgets/detail_youtube_tile.dart';

class DetailScreen extends StatefulWidget {
  final Meal summary;
  const DetailScreen({super.key, required this.summary});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MealDetailCubit>().load(widget.summary.idMeal);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return Scaffold(
      backgroundColor: colors.bg,
      body: BlocBuilder<MealDetailCubit, MealDetailState>(
        builder: (context, state) {
          final meal = state is MealDetailLoaded ? state.meal : null;
          final loading = state is MealDetailLoading || state is MealDetailInitial;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    DetailHeroImage(thumbUrl: widget.summary.strMealThumb),
                    DetailControls(summary: widget.summary, fullMeal: meal),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.summary.strMeal,
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w800,
                              color: colors.text, height: 1.15, letterSpacing: -0.3)),
                      const SizedBox(height: 12),
                      if (loading) ...[
                        AppSpinner(label: t('loading')),
                      ] else if (meal != null) ...[
                        DetailMetaChips(meal: meal),
                        const SizedBox(height: 18),
                        _actionButtons(context, t, meal),
                        const SizedBox(height: 26),
                        _sectionTitle(t('ingredients'), colors),
                        const SizedBox(height: 4),
                        ..._ingredientRows(context, meal),
                        const SizedBox(height: 28),
                        _sectionTitle(t('instructions'), colors),
                        const SizedBox(height: 8),
                        ...meal.instructionSteps.asMap().entries.map((e) =>
                            DetailStepRow(number: e.key + 1, text: e.value)),
                        if (meal.youtubeId != null) ...[
                          const SizedBox(height: 28),
                          _sectionTitle(t('video'), colors),
                          const SizedBox(height: 12),
                          DetailYoutubeTile(ytId: meal.youtubeId!, url: meal.strYoutube ?? ''),
                        ],
                      ] else ...[
                        StateView(icon: Icons.warning_amber_rounded, title: t('errorMsg')),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String text, dynamic colors) => Text(text,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w800,
          color: colors.text, letterSpacing: -0.2));

  Widget _actionButtons(BuildContext context, String Function(String) t, Meal meal) {
    final shopping = context.read<ShoppingCubit>();
    return Row(
      children: [
        Expanded(
          child: AppBtn(
            fullWidth: true,
            onTap: () {
              final steps = meal.instructionSteps;
              if (steps.isEmpty) return;
              Navigator.pushNamed(context, '/cooking',
                  arguments: {'meal': meal, 'steps': steps});
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.local_fire_department),
              const SizedBox(width: 8),
              Text(t('startCooking')),
            ]),
          ),
        ),
        const SizedBox(width: 10),
        AppBtn(
          variant: AppBtnVariant.soft,
          onTap: () {
            shopping.addIngredients(meal.ingredients);
            showAppToast(context, t('added'));
          },
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ],
    );
  }

  List<Widget> _ingredientRows(BuildContext context, Meal meal) {
    final shopping = context.read<ShoppingCubit>();
    return meal.ingredients.map((ing) => DetailIngredientRow(
          ingredient: ing,
          inList: shopping.inList(ing.ingredient),
          onTap: () {
            shopping.addIngredients([ing]);
            showAppToast(context, '${ing.ingredient} · ${context.t('added')}');
          },
        )).toList();
  }
}
