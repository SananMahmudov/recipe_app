import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/meal_card.dart';
import 'settings_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<MealCategory>> _catsFuture;
  late Future<List<String>> _areasFuture;
  late Future<List<Meal>> _popularFuture;
  bool _loadingRandom = false;

  @override
  void initState() {
    super.initState();
    _catsFuture = MealAPI.categories();
    _areasFuture = MealAPI.areas();
    final letter = 'bcgjklmprst'[Random().nextInt(11)];
    _popularFuture =
        MealAPI.byLetter(letter).then((m) => m.take(6).toList());
  }

  Future<void> _openRandom() async {
    if (_loadingRandom) return;
    setState(() => _loadingRandom = true);
    try {
      final m = await MealAPI.random();
      if (m != null && mounted) {
        Navigator.pushNamed(context, '/detail', arguments: m);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingRandom = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final colors = provider.colors;
    final t = provider.t;

    return CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: AppHeader(
            large: true,
            title: t('appName'),
            sub: t('greeting'),
            trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LangToggle(provider: provider),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const SettingsSheet(),
              ),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.surface2,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.tune, size: 18, color: colors.text),
              ),
            ),
          ],
        ),
          ),
        ),

        // ── Tagline + Search entry ───────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('tagline'),
                    style: TextStyle(
                        fontSize: 15, color: colors.textDim)),
                const SizedBox(height: 16),
                _SearchEntry(label: t('searchPlaceholder')),
              ],
            ),
          ),
        ),

        // ── Random / Surprise banner ─────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: _RandomBanner(
              t: t,
              colors: colors,
              loading: _loadingRandom,
              onTap: _openRandom,
            ),
          ),
        ),

        // ── Categories ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 26),
            child: SectionHeader(title: t('categories')),
          ),
        ),
        SliverToBoxAdapter(
          child: FutureBuilder<List<MealCategory>>(
            future: _catsFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const AppSpinner();
              }
              final cats = snap.data ?? [];
              return SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
                  itemCount: cats.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (ctx, i) {
                    final c = cats[i];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(ctx, '/list',
                          arguments: {
                            'title': c.strCategory,
                            'type': 'category',
                          }),
                      child: SizedBox(
                        width: 104,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppImage(
                              url: c.strCategoryThumb,
                              width: 104,
                              height: 84,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              c.strCategory,
                              style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: colors.text),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),

        // ── Cuisines ─────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SectionHeader(title: t('cuisines')),
          ),
        ),
        SliverToBoxAdapter(
          child: FutureBuilder<List<String>>(
            future: _areasFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const AppSpinner();
              }
              final areas = snap.data ?? [];
              return SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
                  itemCount: areas.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 9),
                  itemBuilder: (ctx, i) => AppChip(
                    label: areas[i],
                    icon: Icons.public,
                    onTap: () => Navigator.pushNamed(ctx, '/list',
                        arguments: {
                          'title': areas[i],
                          'type': 'area',
                        }),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Popular ───────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 26),
            child: SectionHeader(title: t('popular')),
          ),
        ),
        SliverToBoxAdapter(
          child: FutureBuilder<List<Meal>>(
            future: _popularFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const AppSpinner();
              }
              final meals = snap.data ?? [];
              if (meals.isEmpty) return const SizedBox.shrink();
              return MealGrid(
                meals: meals,
                subLabel: (m) => m.strArea,
              );
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _LangToggle extends StatelessWidget {
  final AppProvider provider;
  const _LangToggle({required this.provider});

  @override
  Widget build(BuildContext context) {
    final colors = provider.colors;
    return GestureDetector(
      onTap: provider.toggleLang,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.public, size: 16, color: colors.text),
            const SizedBox(width: 6),
            Text(
              provider.lang.toUpperCase(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchEntry extends StatelessWidget {
  final String label;
  const _SearchEntry({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () {
        // Switch to search tab — handled by MainScreen
        final nav = Navigator.of(context, rootNavigator: false);
        nav.pushNamed('/search');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 19, color: colors.textDim),
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(fontSize: 15, color: colors.textDim)),
          ],
        ),
      ),
    );
  }
}

class _RandomBanner extends StatelessWidget {
  final String Function(String) t;
  final dynamic colors;
  final bool loading;
  final VoidCallback onTap;

  const _RandomBanner({
    required this.t,
    required this.colors,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: c.accentGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [c.cardShadow],
      ),
      child: Stack(
        children: [
          // background icon
          Positioned(
            right: -18,
            top: -18,
            child: Opacity(
              opacity: 0.18,
              child: Icon(Icons.shuffle,
                  size: 120, color: c.accentInk),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('randomTitle'),
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: c.accentInk,
                      height: 1.2)),
              const SizedBox(height: 6),
              Text(t('randomSub'),
                  style: TextStyle(
                      fontSize: 14,
                      color: c.accentInk.withValues(alpha: 0.75))),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: loading ? null : onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 11),
                  decoration: BoxDecoration(
                    color: c.accentInk,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      loading
                          ? SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: c.accent))
                          : Icon(Icons.shuffle, size: 17, color: c.accent),
                      const SizedBox(width: 8),
                      Text(t('randomCta'),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: c.accent)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
