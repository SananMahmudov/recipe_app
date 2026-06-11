import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/meal_api_client.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MealApiClient _api;
  Timer? _debounce;

  SearchCubit(this._api) : super(const SearchState());

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  void setMode(SearchMode mode) {
    if (state.mode == mode) return;
    final newState = state.copyWith(mode: mode);
    emit(newState);
    if (state.query.isNotEmpty) _doSearch(state.query, mode);
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(state.copyWith(query: '', loading: false, clearResults: true, hasError: false));
      return;
    }
    emit(state.copyWith(query: trimmed, loading: true, hasError: false));
    _debounce = Timer(
      const Duration(milliseconds: 420),
      () => _doSearch(trimmed, state.mode),
    );
  }

  void clear() {
    _debounce?.cancel();
    emit(const SearchState());
  }

  Future<void> _doSearch(String query, SearchMode mode) async {
    try {
      final results = mode == SearchMode.name
          ? await _api.searchByName(query)
          : await _api.byIngredient(query);
      emit(state.copyWith(loading: false, results: results, hasError: false));
    } catch (_) {
      emit(state.copyWith(loading: false, hasError: true));
    }
  }
}
