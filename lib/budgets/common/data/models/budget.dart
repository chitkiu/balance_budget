import 'package:json_annotation/json_annotation.dart';

import 'budget_date.dart';
import 'budget_repeat_type.dart';
import 'category_budget_info.dart';

part 'budget.g.dart';

abstract class Budget {
  @JsonKey(includeFromJson: false)
  String? _id;

  final String name;
  final BudgetRepeatType repeatType;
  @BudgetDateConverter()
  final BudgetDate startDate;
  @BudgetDateConverter()
  final BudgetDate? endDate;

  String get id => _id ?? '';

  Budget(this.name, this.repeatType, this.startDate, this.endDate);

  double get totalSum;

  @JsonKey(
    name: _typeName,
    includeToJson: true
  )
  String get _type => runtimeType.toString();

  Map<String, dynamic> toJson();

  static const String _typeName = "type";

  static Budget fromJson(MapEntry<String, dynamic> entry) {
    String? type = entry.value[_typeName];
    if (type == (CategoryBudget).toString()) {
      return CategoryBudget.fromJson(entry);
    } else if (type == (TotalBudgetWithCategories).toString()) {
      return TotalBudgetWithCategories.fromJson(entry);
    } else {
      return TotalBudget.fromJson(entry);
    }
  }
}

@JsonSerializable()
class CategoryBudget extends Budget {
  @CategoryBudgetInfoConverter()
  final CategoryBudgetInfo categoryInfo;

  CategoryBudget(
      super.name,
      super.repeatType,
      super.startDate,
      super.endDate,
      this.categoryInfo,
  );

  @override
  double get totalSum => categoryInfo.maxSum;

  factory CategoryBudget.fromJson(MapEntry<String, dynamic> entry) =>
      _$CategoryBudgetFromJson(entry.value).._id = entry.key;

  @override
  Map<String, dynamic> toJson() => _$CategoryBudgetToJson(this);

}

@JsonSerializable()
class TotalBudgetWithCategories extends Budget {
  @CategoryBudgetInfoConverter()
  final List<CategoryBudgetInfo> categoriesInfo;

  TotalBudgetWithCategories(
      super.name,
      super.repeatType,
      super.startDate,
      super.endDate,
      this.categoriesInfo,
  );

  @override
  double get totalSum {
    var totalSum = 0.0;
    for (var element in categoriesInfo) {
      totalSum += element.maxSum;
    }
    return totalSum;
  }

  factory TotalBudgetWithCategories.fromJson(MapEntry<String, dynamic> entry) =>
      _$TotalBudgetWithCategoriesFromJson(entry.value).._id = entry.key;

  @override
  Map<String, dynamic> toJson() => _$TotalBudgetWithCategoriesToJson(this);

}

@JsonSerializable()
class TotalBudget extends Budget {
  @override
  final double totalSum;

  @JsonKey(defaultValue: [])
  final List<String> wallets;

  TotalBudget(
      super.name,
      super.repeatType,
      super.startDate,
      super.endDate,
      this.totalSum,
      this.wallets
  );

  factory TotalBudget.fromJson(MapEntry<String, dynamic> entry) =>
      _$TotalBudgetFromJson(entry.value).._id = entry.key;

  @override
  Map<String, dynamic> toJson() => _$TotalBudgetToJson(this);

}
