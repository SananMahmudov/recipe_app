import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';

class DetailScreen extends StatefulWidget {
  final Meal summary;
  const DetailScreen({super.key, required this.summary});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Meal?> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = MealAPI.lookup(widget.summary.idMeal);
  }

  Future<void> _share(Meal? meal) async {
    final m = meal ?? widget.summary;
    final url = (m.strSource?.isNotEmpty == true)
        ? m.strSource!
        : 'https://www.themealdb.com/meal/${m.idMeal}';
    await Clipboard.setData(ClipboardData(text: '${m.strMeal} — $url'));
    if (mounted) {
      showAppToast(context, context.read<AppProvider>().t('linkCopied'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final colors = provider.colors;
    final t = provider.t;
    final isFav = provider.isFavorite(widget.summary.idMeal);

    return Scaffold(
      backgroundColor: colors.bg,
      body: FutureBuilder<Meal?>(
        future: _mealFuture,
        builder: (context, snap) {
          final meal = snap.data;
          final loading = snap.connectionState != ConnectionState.done;

          return CustomScrollView(
            slivers: [
              // ── Hero image ─────────────────────────────────
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 320,
                      width: double.infinity,
                      child: AppImage(url: widget.summary.strMealThumb),
                    ),
                    // gradient fade to bg
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 140,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              colors.detailFade,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // top controls
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _GlassBtn(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.chevron_left,
                                  size: 22, color: Colors.white),
                            ),
                            Row(
                              children: [
                                _GlassBtn(
                                  onTap: () => _share(meal),
                                  child: const Icon(Icons.share_outlined,
                                      size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                _GlassBtn(
                                  onTap: () =>
                                      provider.toggleFavorite(widget.summary),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: isFav
                                        ? colors.accent
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Title + meta ───────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.summary.strMeal,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: colors.text,
                          height: 1.15,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (!loading && meal != null) ...[
                        // meta chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (meal.strCategory != null)
                              _MetaChip(
                                icon: Icons.local_fire_department,
                                label: meal.strCategory!,
                                colors: colors,
                              ),
                            if (meal.strArea != null)
                              _MetaChip(
                                icon: Icons.public,
                                label: meal.strArea!,
                                colors: colors,
                              ),
                            if (meal.ingredients.isNotEmpty)
                              _MetaChip(
                                icon: Icons.kitchen,
                                label:
                                    '${meal.ingredients.length} ${t('ingredientsCount')}',
                                colors: colors,
                              ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // action buttons
                        Row(
                          children: [
                            Expanded(
                              child: AppBtn(
                                fullWidth: true,
                                onTap: () {
                                  final steps = meal.instructionSteps;
                                  if (steps.isEmpty) return;
                                  Navigator.pushNamed(
                                    context,
                                    '/cooking',
                                    arguments: {
                                      'meal': meal,
                                      'steps': steps,
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                        Icons.local_fire_department),
                                    const SizedBox(width: 8),
                                    Text(t('startCooking')),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            AppBtn(
                              variant: AppBtnVariant.soft,
                              onTap: () {
                                provider.addIngredients(meal.ingredients);
                                showAppToast(context, t('added'));
                              },
                              child: const Icon(
                                  Icons.shopping_bag_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        // ingredients
                        _SectionTitle(t('ingredients'), colors),
                        const SizedBox(height: 4),
                        ...meal.ingredients.map((ing) => _IngredientRow(
                              ingredient: ing,
                              colors: colors,
                              inList: provider
                                  .inShoppingList(ing.ingredient),
                              onTap: () {
                                provider
                                    .addIngredients([ing]);
                                showAppToast(
                                    context,
                                    '${ing.ingredient} · ${t('added')}');
                              },
                            )),
                        const SizedBox(height: 28),
                        // instructions
                        _SectionTitle(t('instructions'), colors),
                        const SizedBox(height: 8),
                        ...meal.instructionSteps
                            .asMap()
                            .entries
                            .map((e) => _StepRow(
                                  number: e.key + 1,
                                  text: e.value,
                                  colors: colors,
                                )),
                        const SizedBox(height: 28),
                        // youtube
                        if (meal.youtubeId != null) ...[
                          _SectionTitle(t('video'), colors),
                          const SizedBox(height: 12),
                          _YoutubeTile(
                            ytId: meal.youtubeId!,
                            colors: colors,
                            label: t('watchVideo'),
                            url: meal.strYoutube ?? '',
                          ),
                        ],
                      ] else if (loading) ...[
                        AppSpinner(label: t('loading')),
                      ] else ...[
                        StateView(
                          icon: Icons.warning_amber_rounded,
                          title: t('errorMsg'),
                        ),
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
}

class _GlassBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassBtn({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.45),
        ),
        child: child,
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic colors;
  const _MetaChip(
      {required this.icon, required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.accent),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: colors.text)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final dynamic colors;
  const _SectionTitle(this.text, this.colors);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: colors.text,
            letterSpacing: -0.2));
  }
}

class _IngredientRow extends StatelessWidget {
  final MealIngredient ingredient;
  final dynamic colors;
  final bool inList;
  final VoidCallback onTap;

  const _IngredientRow({
    required this.ingredient,
    required this.colors,
    required this.inList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                MealAPI.ingredientThumb(ingredient.ingredient),
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 42,
                  height: 42,
                  color: colors.surface2,
                  child: Icon(Icons.kitchen,
                      size: 18, color: colors.textFaint),
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                ingredient.ingredient,
                style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: colors.text),
              ),
            ),
            if (ingredient.measure.isNotEmpty)
              Text(ingredient.measure,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textDim)),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: inList ? colors.accent : colors.surface2,
              ),
              child: Icon(
                inList ? Icons.check : Icons.add,
                size: 15,
                color: inList ? colors.accentInk : colors.textDim,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;
  final dynamic colors;
  const _StepRow(
      {required this.number, required this.text, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accentSoft,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.accent),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 15.5,
                    height: 1.6,
                    color: colors.text.withValues(alpha: 0.92))),
          ),
        ],
      ),
    );
  }
}

class _YoutubeTile extends StatelessWidget {
  final String ytId;
  final String url;
  final String label;
  final dynamic colors;

  const _YoutubeTile({
    required this.ytId,
    required this.url,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: url));
        if (context.mounted) {
          showAppToast(
              context, context.read<AppProvider>().t('linkCopied'));
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                MealAPI.youtubeThumbnail(ytId),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: colors.surface2),
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.65),
              ),
              child: const Icon(Icons.play_arrow,
                  color: Colors.white, size: 32),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
