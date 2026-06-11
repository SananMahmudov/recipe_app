import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/meal_api_client.dart';
import 'meal_list_state.dart';

class MealListCubit extends Cubit<MealListState> {
  final MealApiClient _api;

  MealListCubit(this._api) : super(MealListInitial());

  Future<void> load(String title, String type) async {
    emit(MealListLoading());
    try {
      final meals = type == 'area'
          ? await _api.byArea(title)
          : await _api.byCategory(title);
      emit(MealListLoaded(meals: meals, title: title, type: type));
    } catch (_) {
      emit(MealListError());
    }
  }
}
