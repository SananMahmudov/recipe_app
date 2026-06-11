import '../../../../shared/models/shopping_item.dart';

class ShoppingState {
  final List<ShoppingItem> items;
  final bool buildingFromFavorites;

  const ShoppingState({
    required this.items,
    this.buildingFromFavorites = false,
  });

  factory ShoppingState.initial() =>
      const ShoppingState(items: []);

  ShoppingState copyWith({
    List<ShoppingItem>? items,
    bool? buildingFromFavorites,
  }) =>
      ShoppingState(
        items: items ?? this.items,
        buildingFromFavorites:
            buildingFromFavorites ?? this.buildingFromFavorites,
      );

  int get uncheckedCount => items.where((i) => !i.checked).length;
  bool get isEmpty => items.isEmpty;
}
