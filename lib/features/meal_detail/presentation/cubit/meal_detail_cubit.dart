import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/meal_api_client.dart';
import 'meal_detail_state.dart';

class MealDetailCubit extends Cubit<MealDetailState> {
  final MealApiClient _api;

  MealDetailCubit(this._api) : super(MealDetailInitial());

  Future<void> load(String id) async {
    emit(MealDetailLoading());
    try {
      final meal = await _api.lookup(id);
      if (meal != null) {
        emit(MealDetailLoaded(meal));
      } else {
        emit(MealDetailError());
      }
    } catch (_) {
      emit(MealDetailError());
    }
  }
}
