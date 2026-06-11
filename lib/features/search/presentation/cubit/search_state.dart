import '../../../../shared/models/meal.dart';

enum SearchMode { name, ingredient }

class SearchState {
  final SearchMode mode;
  final String query;
  final bool loading;
  final List<Meal>? results;
  final bool hasError;

  const SearchState({
    this.mode = SearchMode.name,
    this.query = '',
    this.loading = false,
    this.results,
    this.hasError = false,
  });

  bool get isIdle => query.isEmpty;
  bool get isEmpty => !loading && !hasError && (results?.isEmpty ?? false);

  SearchState copyWith({
    SearchMode? mode,
    String? query,
    bool? loading,
    List<Meal>? results,
    bool? hasError,
    bool clearResults = false,
  }) =>
      SearchState(
        mode: mode ?? this.mode,
        query: query ?? this.query,
        loading: loading ?? this.loading,
        results: clearResults ? null : (results ?? this.results),
        hasError: hasError ?? this.hasError,
      );
}
