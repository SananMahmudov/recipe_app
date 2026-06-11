import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/meal_api_client.dart';
import '../../../../features/home/presentation/cubit/home_cubit.dart';
import '../../../../features/home/presentation/screens/home_screen.dart';
import '../../../../features/search/presentation/cubit/search_cubit.dart';
import '../../../../features/search/presentation/screens/search_screen.dart';
import '../../../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../../../features/shopping/presentation/cubit/shopping_cubit.dart';
import '../../../../features/shopping/presentation/screens/shopping_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ShoppingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;
    final api = context.read<MealApiClient>();
    final unchecked = context.watch<ShoppingCubit>().state.uncheckedCount;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit(api)),
        BlocProvider(create: (_) => SearchCubit(api)),
      ],
      child: Scaffold(
        backgroundColor: colors.bg,
        body: IndexedStack(index: _index, children: _screens),
        bottomNavigationBar: _BottomNav(
          index: _index,
          colors: colors,
          t: t,
          uncheckedCount: unchecked,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final AppColors colors;
  final String Function(String) t;
  final int uncheckedCount;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.index,
    required this.colors,
    required this.t,
    required this.uncheckedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, Icons.home, t('tabHome')),
      (Icons.search, Icons.search, t('tabSearch')),
      (Icons.favorite_border, Icons.favorite, t('tabSaved')),
      (Icons.shopping_bag_outlined, Icons.shopping_bag, t('tabList')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.headerBg,
        border: Border(top: BorderSide(color: colors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              index == i ? items[i].$2 : items[i].$1,
                              size: 24,
                              color: index == i ? colors.accent : colors.textFaint,
                            ),
                            if (i == 3 && uncheckedCount > 0)
                              Positioned(
                                top: -5, right: -8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 16,
                                  constraints: const BoxConstraints(minWidth: 16),
                                  decoration: BoxDecoration(
                                    color: colors.accent,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Center(
                                    child: Text('$uncheckedCount',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: colors.accentInk)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(items[i].$3,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: index == i ? colors.accent : colors.textFaint)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
