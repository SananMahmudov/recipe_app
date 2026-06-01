import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/meal_card.dart';

class MealListScreen extends StatefulWidget {
  final String title;
  final String type; // 'category' | 'area'

  const MealListScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  late Future<List<Meal>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.type == 'area'
        ? MealAPI.byArea(widget.title)
        : MealAPI.byCategory(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final colors = provider.colors;
    final t = provider.t;
    final sub =
        widget.type == 'area' ? t('cuisines') : t('categories');

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
            child: FutureBuilder<List<Meal>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return AppSpinner(label: t('loading'));
                }
                if (snap.hasError) {
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
                final meals = snap.data ?? [];
                if (meals.isEmpty) {
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
                          '${meals.length} ${t('recipes')}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.textDim),
                        ),
                      ),
                      MealGrid(meals: meals),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
