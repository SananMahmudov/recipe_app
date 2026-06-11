import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/models/meal.dart';
import '../../shared/models/meal_category.dart';

class MealApiClient {
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';
  final _cache = <String, dynamic>{};

  Future<dynamic> _get(String path) async {
    if (_cache.containsKey(path)) return _cache[path];
    final res = await http.get(Uri.parse('$_base$path'));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    final data = jsonDecode(res.body);
    _cache[path] = data;
    return data;
  }

  Future<List<MealCategory>> categories() async {
    final data = await _get('/categories.php');
    return ((data['categories'] as List?) ?? [])
        .map((e) => MealCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> areas() async {
    final data = await _get('/list.php?a=list');
    return ((data['meals'] as List?) ?? [])
        .map((e) => e['strArea'] as String)
        .toList();
  }

  Future<List<Meal>> byCategory(String c) async {
    final data = await _get('/filter.php?c=${Uri.encodeComponent(c)}');
    return ((data['meals'] as List?) ?? [])
        .map((e) => Meal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Meal>> byArea(String a) async {
    final data = await _get('/filter.php?a=${Uri.encodeComponent(a)}');
    return ((data['meals'] as List?) ?? [])
        .map((e) => Meal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Meal>> byIngredient(String i) async {
    final query = i.trim().replaceAll(RegExp(r'\s+'), '_');
    final data = await _get('/filter.php?i=${Uri.encodeComponent(query)}');
    return ((data['meals'] as List?) ?? [])
        .map((e) => Meal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Meal>> searchByName(String s) async {
    final data = await _get('/search.php?s=${Uri.encodeComponent(s)}');
    return ((data['meals'] as List?) ?? [])
        .map((e) => Meal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Meal>> byLetter(String l) async {
    final data = await _get('/search.php?f=${Uri.encodeComponent(l)}');
    return ((data['meals'] as List?) ?? [])
        .map((e) => Meal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Meal?> lookup(String id) async {
    final data = await _get('/lookup.php?i=${Uri.encodeComponent(id)}');
    final meals = (data['meals'] as List?) ?? [];
    if (meals.isEmpty) return null;
    return Meal.fromJson(meals[0] as Map<String, dynamic>);
  }

  Future<Meal?> random() async {
    final res = await http.get(Uri.parse('$_base/random.php'));
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body);
    final meals = (data['meals'] as List?) ?? [];
    if (meals.isEmpty) return null;
    return Meal.fromJson(meals[0] as Map<String, dynamic>);
  }

  static String ingredientThumb(String ingredient, {bool small = true}) {
    final size = small ? '-Small' : '';
    return 'https://www.themealdb.com/images/ingredients/${Uri.encodeComponent(ingredient)}$size.png';
  }

  static String youtubeThumbnail(String ytId) =>
      'https://img.youtube.com/vi/$ytId/hqdefault.jpg';
}
