import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'shopping_screen.dart';
export 'settings_sheet.dart';

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
    final provider = context.watch<AppProvider>();
    final colors = provider.colors;
    final t = provider.t;

    return Scaffold(
      backgroundColor: colors.bg,
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: _BottomNav(
        index: _index,
        colors: colors,
        t: t,
        uncheckedCount: provider.shoppingUncheckedCount,
        onTap: (i) => setState(() => _index = i),
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
      (Icons.home_outlined, Icons.home, t('tabHome'), 'home'),
      (Icons.search, Icons.search, t('tabSearch'), 'search'),
      (Icons.favorite_border, Icons.favorite, t('tabSaved'), 'fav'),
      (Icons.shopping_bag_outlined, Icons.shopping_bag, t('tabList'), 'list'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.headerBg,
        border: Border(
            top: BorderSide(color: colors.border, width: 0.5)),
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
                              index == i
                                  ? items[i].$2
                                  : items[i].$1,
                              size: 24,
                              color: index == i
                                  ? colors.accent
                                  : colors.textFaint,
                            ),
                            // badge for shopping list
                            if (i == 3 && uncheckedCount > 0)
                              Positioned(
                                top: -5,
                                right: -8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  height: 16,
                                  constraints: const BoxConstraints(
                                      minWidth: 16),
                                  decoration: BoxDecoration(
                                    color: colors.accent,
                                    borderRadius:
                                        BorderRadius.circular(99),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$uncheckedCount',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: colors.accentInk),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[i].$3,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: index == i
                                ? colors.accent
                                : colors.textFaint,
                          ),
                        ),
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

