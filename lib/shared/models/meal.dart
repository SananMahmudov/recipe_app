import 'dart:convert';

class MealIngredient {
  final String ingredient;
  final String measure;

  const MealIngredient({required this.ingredient, required this.measure});
}

class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strYoutube;
  final String? strSource;
  final List<MealIngredient> ingredients;

  const Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strYoutube,
    this.strSource,
    this.ingredients = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <MealIngredient>[];
    for (int i = 1; i <= 20; i++) {
      final ing = ((json['strIngredient$i'] as String?) ?? '').trim();
      final mea = ((json['strMeasure$i'] as String?) ?? '').trim();
      if (ing.isNotEmpty && ing.toLowerCase() != 'null') {
        ingredients.add(MealIngredient(
          ingredient: ing,
          measure:
              (mea.isNotEmpty && mea.toLowerCase() != 'null') ? mea : '',
        ));
      }
    }
    return Meal(
      idMeal: (json['idMeal'] as String?) ?? '',
      strMeal: (json['strMeal'] as String?) ?? '',
      strMealThumb: (json['strMealThumb'] as String?) ?? '',
      strCategory: json['strCategory'] as String?,
      strArea: json['strArea'] as String?,
      strInstructions: json['strInstructions'] as String?,
      strYoutube: json['strYoutube'] as String?,
      strSource: json['strSource'] as String?,
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMeal': idMeal,
        'strMeal': strMeal,
        'strMealThumb': strMealThumb,
        if (strCategory != null) 'strCategory': strCategory,
        if (strArea != null) 'strArea': strArea,
      };

  static Meal fromJsonString(String s) =>
      Meal.fromJson(jsonDecode(s) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());

  List<String> get instructionSteps {
    if (strInstructions == null || strInstructions!.isEmpty) return [];
    return strInstructions!
        .split(RegExp(r'\r?\n+'))
        .map((s) => s.trim())
        .where((s) => s.length > 1)
        .toList();
  }

  String? get youtubeId {
    if (strYoutube == null || strYoutube!.isEmpty) return null;
    final m = RegExp(r'[?&]v=([^&]+)').firstMatch(strYoutube!) ??
        RegExp(r'youtu\.be/([^?]+)').firstMatch(strYoutube!);
    return m?.group(1);
  }
}
