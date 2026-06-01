import 'dart:convert';

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

class MealIngredient {
  final String ingredient;
  final String measure;

  const MealIngredient({required this.ingredient, required this.measure});
}

class MealCategory {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String? strCategoryDescription;

  const MealCategory({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    this.strCategoryDescription,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) => MealCategory(
        idCategory: (json['idCategory'] as String?) ?? '',
        strCategory: (json['strCategory'] as String?) ?? '',
        strCategoryThumb: (json['strCategoryThumb'] as String?) ?? '',
        strCategoryDescription: json['strCategoryDescription'] as String?,
      );
}

class ShoppingItem {
  final String key;
  final String name;
  final List<String> measures;
  final bool checked;

  const ShoppingItem({
    required this.key,
    required this.name,
    this.measures = const [],
    this.checked = false,
  });

  ShoppingItem copyWith({bool? checked, List<String>? measures}) =>
      ShoppingItem(
        key: key,
        name: name,
        measures: measures ?? this.measures,
        checked: checked ?? this.checked,
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
        'measures': measures,
        'checked': checked,
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        key: (json['key'] as String?) ?? '',
        name: (json['name'] as String?) ?? '',
        measures: List<String>.from((json['measures'] as List?) ?? []),
        checked: (json['checked'] as bool?) ?? false,
      );

  static ShoppingItem fromJsonString(String s) =>
      ShoppingItem.fromJson(jsonDecode(s) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());
}
