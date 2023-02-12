// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      title: json['title'] as String,
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'title': instance.title,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.spend: 'spend',
  TransactionType.income: 'income',
};
