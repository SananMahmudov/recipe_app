import 'dart:convert';

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
