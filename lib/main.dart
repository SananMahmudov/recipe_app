import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/meal_api_client.dart';
import 'core/theme/app_theme.dart';
import 'shared/models/meal.dart';
import 'features/app_settings/presentation/cubit/app_settings_cubit.dart';
import 'features/app_settings/presentation/screens/settings_sheet.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';
import 'features/shopping/presentation/cubit/shopping_cubit.dart';
import 'features/main/presentation/screens/main_screen.dart';
import 'features/meal_detail/presentation/cubit/meal_detail_cubit.dart';
import 'features/meal_detail/presentation/screens/detail_screen.dart';
import 'features/meal_list/presentation/cubit/meal_list_cubit.dart';
import 'features/meal_list/presentation/screens/meal_list_screen.dart';
import 'features/cooking/presentation/screens/cooking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  final prefs = await SharedPreferences.getInstance();
  final apiClient = MealApiClient();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiClient),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AppSettingsCubit(prefs)),
          BlocProvider(create: (_) => FavoritesCubit(prefs)),
          BlocProvider(create: (ctx) => ShoppingCubit(prefs, ctx.read<MealApiClient>())),
        ],
        child: const RecipeApp(),
      ),
    ),
  );
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsCubit>().state;

    return MaterialApp(
      title: 'Recipes',
      debugShowCheckedModeBanner: false,
      themeMode: settings.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light(settings.accent),
      darkTheme: AppTheme.dark(settings.accent),
      home: const MainScreen(),
      onGenerateRoute: (routeSettings) {
        final api = context.read<MealApiClient>();
        switch (routeSettings.name) {
          case '/detail':
            final meal = routeSettings.arguments as Meal;
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => MealDetailCubit(api),
                child: DetailScreen(summary: meal),
              ),
            );

          case '/list':
            final args = routeSettings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => MealListCubit(api),
                child: MealListScreen(
                  title: args['title']!,
                  type: args['type']!,
                ),
              ),
            );

          case '/cooking':
            final args = routeSettings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => CookingScreen(
                meal: args['meal'] as Meal,
                steps: List<String>.from(args['steps'] as List),
              ),
            );

          case '/settings':
            return MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => Scaffold(
                body: DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.4,
                  maxChildSize: 0.9,
                  expand: false,
                  builder: (_, _) => const SettingsSheet(),
                ),
              ),
            );
        }
        return null;
      },
    );
  }
}
