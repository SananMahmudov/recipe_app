import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'providers/app_provider.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/meal_list_screen.dart';
import 'screens/cooking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  final provider = AppProvider();
  await provider.init();
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const RecipeApp(),
    ),
  );
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return MaterialApp(
      title: 'Recipes',
      debugShowCheckedModeBanner: false,
      themeMode:
          provider.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light(provider.accent),
      darkTheme: AppTheme.dark(provider.accent),
      home: const MainScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/detail':
            final meal = settings.arguments as Meal;
            return MaterialPageRoute(
              builder: (_) => DetailScreen(summary: meal),
            );

          case '/list':
            final args = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (_) => MealListScreen(
                title: args['title']!,
                type: args['type']!,
              ),
            );

          case '/cooking':
            final args =
                settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => CookingScreen(
                meal: args['meal'] as Meal,
                steps: List<String>.from(
                    args['steps'] as List),
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
                  builder: (_, controller) =>
                      const SettingsSheet(),
                ),
              ),
            );
        }
        return null;
      },
    );
  }
}
