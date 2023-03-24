// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      sum: (json['sum'] as num).toDouble(),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      categoryId: json['categoryId'] as String?,
      accountId: json['accountId'] as String,
      time: const EpochDateTimeConverter().fromJson(json['time'] as int),
      creationTime:
          const EpochDateTimeConverter().fromJson(json['creationTime'] as int),
      comment: json['comment'] as String?,
      additionalData: json['additionalData'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'sum': instance.sum,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'categoryId': instance.categoryId,
      'accountId': instance.accountId,
      'time': const EpochDateTimeConverter().toJson(instance.time),
      'creationTime':
          const EpochDateTimeConverter().toJson(instance.creationTime),
      'comment': instance.comment,
      'additionalData': instance.additionalData,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.setInitialBalance: 'setInitialBalance',
  TransactionType.spend: 'spend',
  TransactionType.income: 'income',
  TransactionType.transfer: 'transfer',
};
