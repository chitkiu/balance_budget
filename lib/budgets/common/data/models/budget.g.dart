// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryBudget _$CategoryBudgetFromJson(Map<String, dynamic> json) =>
    CategoryBudget(
      json['name'] as String,
      $enumDecode(_$BudgetRepeatTypeEnumMap, json['repeatType']),
      const EpochWithoutTimeDateTimeConverter()
          .fromJson(json['startDate'] as int),
      _$JsonConverterFromJson<int, DateTime>(
          json['endDate'], const EpochWithoutTimeDateTimeConverter().fromJson),
      const CategoryBudgetInfoConverter()
          .fromJson(json['categoryInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryBudgetToJson(CategoryBudget instance) =>
    <String, dynamic>{
      'name': instance.name,
      'repeatType': _$BudgetRepeatTypeEnumMap[instance.repeatType]!,
      'startDate':
          const EpochWithoutTimeDateTimeConverter().toJson(instance.startDate),
      'endDate': _$JsonConverterToJson<int, DateTime>(
          instance.endDate, const EpochWithoutTimeDateTimeConverter().toJson),
      'type': instance._type,
      'categoryInfo':
          const CategoryBudgetInfoConverter().toJson(instance.categoryInfo),
    };

const _$BudgetRepeatTypeEnumMap = {
  BudgetRepeatType.oneTime: 'oneTime',
  BudgetRepeatType.monthly: 'monthly',
  BudgetRepeatType.quarter: 'quarter',
  BudgetRepeatType.semiYear: 'semiYear',
  BudgetRepeatType.year: 'year',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

MultiCategoryBudget _$TotalBudgetWithCategoriesFromJson(
        Map<String, dynamic> json) =>
    MultiCategoryBudget(
      json['name'] as String,
      $enumDecode(_$BudgetRepeatTypeEnumMap, json['repeatType']),
      const EpochWithoutTimeDateTimeConverter()
          .fromJson(json['startDate'] as int),
      _$JsonConverterFromJson<int, DateTime>(
          json['endDate'], const EpochWithoutTimeDateTimeConverter().fromJson),
      (json['categoriesInfo'] as List<dynamic>)
          .map((e) => const CategoryBudgetInfoConverter()
              .fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TotalBudgetWithCategoriesToJson(
        MultiCategoryBudget instance) =>
    <String, dynamic>{
      'name': instance.name,
      'repeatType': _$BudgetRepeatTypeEnumMap[instance.repeatType]!,
      'startDate':
          const EpochWithoutTimeDateTimeConverter().toJson(instance.startDate),
      'endDate': _$JsonConverterToJson<int, DateTime>(
          instance.endDate, const EpochWithoutTimeDateTimeConverter().toJson),
      'type': instance._type,
      'categoriesInfo': instance.categoriesInfo
          .map(const CategoryBudgetInfoConverter().toJson)
          .toList(),
    };

TotalBudget _$TotalBudgetFromJson(Map<String, dynamic> json) => TotalBudget(
      json['name'] as String,
      $enumDecode(_$BudgetRepeatTypeEnumMap, json['repeatType']),
      const EpochWithoutTimeDateTimeConverter()
          .fromJson(json['startDate'] as int),
      _$JsonConverterFromJson<int, DateTime>(
          json['endDate'], const EpochWithoutTimeDateTimeConverter().fromJson),
      (json['totalSum'] as num).toDouble(),
      (json['wallets'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
    );

Map<String, dynamic> _$TotalBudgetToJson(TotalBudget instance) =>
    <String, dynamic>{
      'name': instance.name,
      'repeatType': _$BudgetRepeatTypeEnumMap[instance.repeatType]!,
      'startDate':
          const EpochWithoutTimeDateTimeConverter().toJson(instance.startDate),
      'endDate': _$JsonConverterToJson<int, DateTime>(
          instance.endDate, const EpochWithoutTimeDateTimeConverter().toJson),
      'type': instance._type,
      'totalSum': instance.totalSum,
      'wallets': instance.wallets,
    };
