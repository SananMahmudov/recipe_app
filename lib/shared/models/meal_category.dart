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
        strCategoryDescription:
            json['strCategoryDescription'] as String?,
      );
}
