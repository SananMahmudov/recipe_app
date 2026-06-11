import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/section_header.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_lang_toggle.dart';
import '../widgets/home_search_entry.dart';
import '../widgets/home_random_banner.dart';
import '../widgets/home_category_list.dart';
import '../widgets/home_cuisine_list.dart';
import '../widgets/home_popular_section.dart';
import '../../../app_settings/presentation/screens/settings_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final loaded = state is HomeLoaded ? state : null;
        final isLoading = state is HomeLoading || state is HomeInitial;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AppHeader(
                large: true,
                title: t('appName'),
                sub: t('greeting'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HomeLangToggle(),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const SettingsSheet(),
                      ),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                            color: colors.surface2, shape: BoxShape.circle),
                        child: Icon(Icons.tune, size: 18, color: colors.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('tagline'),
                        style: TextStyle(fontSize: 15, color: colors.textDim)),
                    const SizedBox(height: 16),
                    const HomeSearchEntry(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
                child: HomeRandomBanner(
                  loading: loaded?.loadingRandom ?? false,
                  onTap: () => context.read<HomeCubit>().fetchRandom(
                    (meal) => Navigator.pushNamed(context, '/detail', arguments: meal),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(padding: const EdgeInsets.only(top: 26),
                  child: SectionHeader(title: t('categories'))),
            ),
            SliverToBoxAdapter(
              child: HomeCategoryList(
                categories: loaded?.categories,
                loading: isLoading,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(padding: const EdgeInsets.only(top: 24),
                  child: SectionHeader(title: t('cuisines'))),
            ),
            SliverToBoxAdapter(
              child: HomeCuisineList(areas: loaded?.areas, loading: isLoading),
            ),
            SliverToBoxAdapter(
              child: Padding(padding: const EdgeInsets.only(top: 26),
                  child: SectionHeader(title: t('popular'))),
            ),
            SliverToBoxAdapter(
              child: HomePopularSection(popular: loaded?.popular, loading: isLoading),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}
