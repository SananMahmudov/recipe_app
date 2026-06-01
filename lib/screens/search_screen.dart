import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/meal_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _mode = 'name'; // 'name' | 'ingredient'
  final _controller = TextEditingController();
  String _debounced = '';
  Future<List<Meal>>? _resultFuture;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    final q = _controller.text.trim();
    Future.delayed(const Duration(milliseconds: 420), () {
      if (!mounted) return;
      final current = _controller.text.trim();
      if (current == q && current != _debounced) {
        setState(() {
          _debounced = current;
          _resultFuture = current.isEmpty
              ? null
              : (_mode == 'name'
                  ? MealAPI.searchByName(current)
                  : MealAPI.byIngredient(current));
        });
      }
    });
  }

  void _switchMode(String mode) {
    setState(() {
      _mode = mode;
      _debounced = _controller.text.trim();
      _resultFuture = _debounced.isEmpty
          ? null
          : (_mode == 'name'
              ? MealAPI.searchByName(_debounced)
              : MealAPI.byIngredient(_debounced));
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final colors = provider.colors;
    final t = provider.t;

    return Column(
      children: [
        AppHeader(large: true, title: t('tabSearch')),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Column(
            children: [
              // ── Segmented control ──────────────────────────
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _Segment(
                      label: t('byName'),
                      active: _mode == 'name',
                      colors: colors,
                      onTap: () => _switchMode('name'),
                    ),
                    _Segment(
                      label: t('byIngredient'),
                      active: _mode == 'ingredient',
                      colors: colors,
                      onTap: () => _switchMode('ingredient'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // ── Input ──────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 19, color: colors.textDim),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: false,
                        style:
                            TextStyle(fontSize: 16, color: colors.text),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: _mode == 'name'
                              ? t('searchPlaceholder')
                              : t('searchIngPlaceholder'),
                          hintStyle: TextStyle(
                              fontSize: 15, color: colors.textFaint),
                        ),
                        cursorColor: colors.accent,
                      ),
                    ),
                    if (_controller.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _controller.clear();
                          setState(() {
                            _debounced = '';
                            _resultFuture = null;
                          });
                        },
                        child:
                            Icon(Icons.close, size: 18, color: colors.textDim),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Results ────────────────────────────────────────
        Expanded(
          child: _resultFuture == null
              ? StateView(
                  icon: Icons.search,
                  title: t('tabSearch'),
                  hint: t('searchPrompt'),
                )
              : FutureBuilder<List<Meal>>(
                  future: _resultFuture,
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return AppSpinner(label: t('loading'));
                    }
                    if (snap.hasError) {
                      return StateView(
                          icon: Icons.warning_amber_rounded,
                          title: t('errorMsg'));
                    }
                    final meals = snap.data ?? [];
                    if (meals.isEmpty) {
                      return StateView(
                        title: t('noResults'),
                        hint: '"$_debounced"',
                      );
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      child: MealGrid(
                        meals: meals,
                        subLabel: (m) => m.strArea,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool active;
  final dynamic colors;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.active,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
