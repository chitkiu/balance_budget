import 'package:json_annotation/json_annotation.dart';

import '../../../../common/data/models/epoch_date_time_converter.dart';
import '../../../../common/data/models/transaction_type.dart';

part 'transaction.g.dart';

abstract class Transaction {
  @JsonKey(includeFromJson: false)
  String? _id;
  final double sum;
  final TransactionType transactionType;
  final String walletId;
  @EpochWithoutTimeDateTimeConverter()
  final DateTime time;
  @EpochDateTimeConverter()
  final DateTime creationTime;
  final String? comment;

  String get id => _id ?? '';

  Transaction(
      {required this.sum,
      required this.transactionType,
      required this.walletId,
      required this.time,
      required this.creationTime,
      this.comment});

  factory Transaction.fromJson(MapEntry<dynamic, dynamic> json) {
    String transactionType = json.value["transactionType"];
    if (transactionType == TransactionType.transfer.name) {
      return TransferTransaction.fromJson(json);
    } else if (transactionType == TransactionType.setInitialBalance.name) {
      return SetBalanceTransaction.fromJson(json);
    } else {
      return CommonTransaction.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          sum == other.sum &&
          transactionType == other.transactionType &&
          walletId == other.walletId &&
          time == other.time &&
          creationTime == other.creationTime &&
          comment == other.comment;

  @override
  int get hashCode =>
      _id.hashCode ^
      sum.hashCode ^
      transactionType.hashCode ^
      walletId.hashCode ^
      time.hashCode ^
      creationTime.hashCode ^
      comment.hashCode;

  @override
  String toString() {
    return 'Transaction{_id: $_id, sum: $sum, transactionType: $transactionType, walletId: $walletId, time: $time, creationTime: $creationTime, comment: $comment}';
  }
}

@JsonSerializable()
class CommonTransaction extends Transaction {
  final String categoryId;

  CommonTransaction({required super.sum, required super.transactionType, required this.categoryId, required super.walletId, required super.time, required super.creationTime, super.comment});

  factory CommonTransaction.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$CommonTransactionFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$CommonTransactionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CommonTransaction &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId;

  @override
  int get hashCode => super.hashCode ^ categoryId.hashCode;

  Transaction copyWith(
      {double? sum,
        TransactionType? transactionType,
        String? categoryId,
        String? walletId,
        DateTime? time,
        DateTime? creationTime,
        String? comment}) {
    var finalComment = this.comment;
    if (comment == '') {
      finalComment = null;
    } else if (comment?.isNotEmpty == true) {
      finalComment = comment;
    }
    return CommonTransaction(
      sum: sum ?? this.sum,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      walletId: walletId ?? this.walletId,
      time: time ?? this.time,
      comment: finalComment,
      creationTime: creationTime ?? this.creationTime,
    ).._id = _id;
  }

}

@JsonSerializable()
class SetBalanceTransaction extends Transaction {
  SetBalanceTransaction({required super.sum, required super.transactionType, required super.walletId, required super.time, required super.creationTime});

  factory SetBalanceTransaction.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$SetBalanceTransactionFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$SetBalanceTransactionToJson(this);

  Transaction copyWith(
      {double? sum,
        TransactionType? transactionType,
        String? categoryId,
        String? walletId,
        DateTime? time,
        DateTime? creationTime,
        String? comment}) {
    return SetBalanceTransaction(
      sum: sum ?? this.sum,
      transactionType: transactionType ?? this.transactionType,
      walletId: walletId ?? this.walletId,
      time: time ?? this.time,
      creationTime: creationTime ?? this.creationTime,
    ).._id = _id;
  }

}

@JsonSerializable()
class TransferTransaction extends Transaction {
  final String toWalletId;

  TransferTransaction({
    required super.sum,
    required super.transactionType,
    required super.walletId,
    required super.time,
    required super.creationTime,
    required this.toWalletId,
    super.comment,
  });

  factory TransferTransaction.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$TransferTransactionFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$TransferTransactionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is TransferTransaction &&
          runtimeType == other.runtimeType &&
          toWalletId == other.toWalletId;

  @override
  int get hashCode => super.hashCode ^ toWalletId.hashCode;

  Transaction copyWith(
      {double? sum,
        TransactionType? transactionType,
        String? categoryId,
        String? walletId,
        String? toWalletId,
        DateTime? time,
        DateTime? creationTime,
        String? comment}) {
    return TransferTransaction(
      sum: sum ?? this.sum,
      transactionType: transactionType ?? this.transactionType,
      walletId: walletId ?? this.walletId,
      toWalletId: toWalletId ?? this.toWalletId,
      time: time ?? this.time,
      creationTime: creationTime ?? this.creationTime,
      comment: comment ?? this.comment,
    ).._id = _id;
  }

  @override
  String toString() {
    return '${super.toString()}, toWalletId: $toWalletId}';
  }
}
