import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/meal_api_client.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MealApiClient _api;

  HomeCubit(this._api) : super(HomeInitial());

  Future<void> load() async {
    emit(HomeLoading());
    try {
      final letter = 'bcgjklmprst'[Random().nextInt(11)];
      final results = await Future.wait([
        _api.categories(),
        _api.areas(),
        _api.byLetter(letter).then((m) => m.take(6).toList()),
      ]);
      emit(HomeLoaded(
        categories: results[0] as dynamic,
        areas: results[1] as dynamic,
        popular: results[2] as dynamic,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> fetchRandom(void Function(dynamic meal) onResult) async {
    final current = state;
    if (current is! HomeLoaded) return;
    emit(current.copyWith(loadingRandom: true));
    try {
      final meal = await _api.random();
      if (meal != null) onResult(meal);
    } catch (_) {}
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(loadingRandom: false));
    }
  }
}
