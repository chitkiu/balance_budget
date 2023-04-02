import 'package:json_annotation/json_annotation.dart';

part 'category_budget_info.g.dart';

@JsonSerializable()
class CategoryBudgetInfo {
  final String categoryId;
  final double maxSum;
  @JsonKey(defaultValue: [])
  final List<String> wallets;

  CategoryBudgetInfo({required this.categoryId, required this.maxSum, required this.wallets});

  factory CategoryBudgetInfo.fromJson(Map<String, dynamic> json) => _$CategoryBudgetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryBudgetInfoToJson(this);
}

class CategoryBudgetInfoConverter implements JsonConverter<CategoryBudgetInfo, Map<String, dynamic>> {
  const CategoryBudgetInfoConverter();

  @override
  CategoryBudgetInfo fromJson(Map<String, dynamic> json) => _$CategoryBudgetInfoFromJson(json);

  @override
  Map<String, dynamic> toJson(CategoryBudgetInfo instance) => _$CategoryBudgetInfoToJson(instance);
}
