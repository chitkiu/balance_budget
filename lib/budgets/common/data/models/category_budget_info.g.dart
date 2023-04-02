// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_budget_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryBudgetInfo _$CategoryBudgetInfoFromJson(Map<String, dynamic> json) =>
    CategoryBudgetInfo(
      categoryId: json['categoryId'] as String,
      maxSum: (json['maxSum'] as num).toDouble(),
      wallets: (json['wallets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CategoryBudgetInfoToJson(CategoryBudgetInfo instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'maxSum': instance.maxSum,
      'wallets': instance.wallets,
    };
