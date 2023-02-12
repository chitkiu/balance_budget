// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      sum: (json['sum'] as num).toDouble(),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      categoryId: json['categoryId'] as String,
      accountId: json['accountId'] as String,
      time: DateTime.parse(json['time'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'sum': instance.sum,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'categoryId': instance.categoryId,
      'accountId': instance.accountId,
      'time': instance.time.toIso8601String(),
      'comment': instance.comment,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.spend: 'spend',
  TransactionType.income: 'income',
};
