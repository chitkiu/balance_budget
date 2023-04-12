// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      title: json['title'] as String,
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      icon: json['icon'] == null
          ? Icons.not_interested
          : const IconConverter().fromJson(json['icon'] as String?),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'title': instance.title,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'icon': const IconConverter().toJson(instance.icon),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.setInitialBalance: 'setInitialBalance',
  TransactionType.expense: 'expense',
  TransactionType.income: 'income',
  TransactionType.transfer: 'transfer',
};
