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
      walletId: json['walletId'] as String,
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
      'walletId': instance.walletId,
      'time': const EpochWithoutTimeDateTimeConverter().toJson(instance.time),
      'creationTime':
          const EpochDateTimeConverter().toJson(instance.creationTime),
      'comment': instance.comment,
      'categoryId': instance.categoryId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.setInitialBalance: 'setInitialBalance',
  TransactionType.expense: 'expense',
  TransactionType.income: 'income',
  TransactionType.transfer: 'transfer',
};

SetBalanceTransaction _$SetBalanceTransactionFromJson(
        Map<String, dynamic> json) =>
    SetBalanceTransaction(
      sum: (json['sum'] as num).toDouble(),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      walletId: json['walletId'] as String,
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
      'walletId': instance.walletId,
      'time': const EpochWithoutTimeDateTimeConverter().toJson(instance.time),
      'creationTime':
          const EpochDateTimeConverter().toJson(instance.creationTime),
    };

TransferTransaction _$TransferTransactionFromJson(Map<String, dynamic> json) =>
    TransferTransaction(
      sum: (json['sum'] as num).toDouble(),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      walletId: json['walletId'] as String,
      time: const EpochWithoutTimeDateTimeConverter()
          .fromJson(json['time'] as int),
      creationTime:
          const EpochDateTimeConverter().fromJson(json['creationTime'] as int),
      toWalletId: json['toWalletId'] as String,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$TransferTransactionToJson(
        TransferTransaction instance) =>
    <String, dynamic>{
      'sum': instance.sum,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'walletId': instance.walletId,
      'time': const EpochWithoutTimeDateTimeConverter().toJson(instance.time),
      'creationTime':
          const EpochDateTimeConverter().toJson(instance.creationTime),
      'comment': instance.comment,
      'toWalletId': instance.toWalletId,
    };
