// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonTransaction _$CommonTransactionFromJson(Map<String, dynamic> json) =>
    CommonTransaction(
      sum: (json['sum'] as num).toDouble(),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      categoryId: json['categoryId'] as String,
      accountId: json['accountId'] as String,
      time: const EpochWithoutTimeDateTimeConverter()
          .fromJson(json['time'] as int),
      creationTime:
          const EpochDateTimeConverter().fromJson(json['creationTime'] as int),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$CommonTransactionToJson(CommonTransaction instance) =>
    <String, dynamic>{
      'sum': instance.sum,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'accountId': instance.accountId,
      'time': const EpochWithoutTimeDateTimeConverter().toJson(instance.time),
      'creationTime':
          const EpochDateTimeConverter().toJson(instance.creationTime),
      'comment': instance.comment,
      'categoryId': instance.categoryId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.setInitialBalance: 'setInitialBalance',
  TransactionType.spend: 'spend',
  TransactionType.income: 'income',
  TransactionType.transfer: 'transfer',
};

SetBalanceTransaction _$SetBalanceTransactionFromJson(
        Map<String, dynamic> json) =>
    SetBalanceTransaction(
      sum: (json['sum'] as num).toDouble(),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      accountId: json['accountId'] as String,
      time: const EpochWithoutTimeDateTimeConverter()
          .fromJson(json['time'] as int),
      creationTime:
          const EpochDateTimeConverter().fromJson(json['creationTime'] as int),
    );

Map<String, dynamic> _$SetBalanceTransactionToJson(
        SetBalanceTransaction instance) =>
    <String, dynamic>{
      'sum': instance.sum,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'accountId': instance.accountId,
      'time': const EpochWithoutTimeDateTimeConverter().toJson(instance.time),
      'creationTime':
          const EpochDateTimeConverter().toJson(instance.creationTime),
    };

TransferTransaction _$TransferTransactionFromJson(Map<String, dynamic> json) =>
    TransferTransaction(
      sum: (json['sum'] as num).toDouble(),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      accountId: json['accountId'] as String,
      time: const EpochWithoutTimeDateTimeConverter()
          .fromJson(json['time'] as int),
      creationTime:
          const EpochDateTimeConverter().fromJson(json['creationTime'] as int),
      toAccountId: json['toAccountId'] as String,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$TransferTransactionToJson(
        TransferTransaction instance) =>
    <String, dynamic>{
      'sum': instance.sum,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'accountId': instance.accountId,
      'time': const EpochWithoutTimeDateTimeConverter().toJson(instance.time),
      'creationTime':
          const EpochDateTimeConverter().toJson(instance.creationTime),
      'comment': instance.comment,
      'toAccountId': instance.toAccountId,
    };
