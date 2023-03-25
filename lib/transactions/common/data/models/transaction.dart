import 'package:json_annotation/json_annotation.dart';

import '../../../../common/data/models/epoch_date_time_converter.dart';
import '../../../../common/data/models/transaction_type.dart';

part 'transaction.g.dart';

abstract class Transaction {
  @JsonKey(includeFromJson: false)
  String? _id;
  final double sum;
  final TransactionType transactionType;
  final String accountId;
  @EpochWithoutTimeDateTimeConverter()
  final DateTime time;
  @EpochDateTimeConverter()
  final DateTime creationTime;
  final String? comment;

  String get id => _id ?? '';

  Transaction(
      {required this.sum,
      required this.transactionType,
      required this.accountId,
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
          accountId == other.accountId &&
          time == other.time &&
          creationTime == other.creationTime &&
          comment == other.comment;

  @override
  int get hashCode =>
      _id.hashCode ^
      sum.hashCode ^
      transactionType.hashCode ^
      accountId.hashCode ^
      time.hashCode ^
      creationTime.hashCode ^
      comment.hashCode;

  @override
  String toString() {
    return 'Transaction{_id: $_id, sum: $sum, transactionType: $transactionType, accountId: $accountId, time: $time, creationTime: $creationTime, comment: $comment}';
  }
}

@JsonSerializable()
class CommonTransaction extends Transaction {
  final String categoryId;

  CommonTransaction({required super.sum, required super.transactionType, required this.categoryId, required super.accountId, required super.time, required super.creationTime, super.comment});

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
        String? accountId,
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
      accountId: accountId ?? this.accountId,
      time: time ?? this.time,
      comment: finalComment,
      creationTime: creationTime ?? this.creationTime,
    ).._id = _id;
  }

}

@JsonSerializable()
class SetBalanceTransaction extends Transaction {
  SetBalanceTransaction({required super.sum, required super.transactionType, required super.accountId, required super.time, required super.creationTime});

  factory SetBalanceTransaction.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$SetBalanceTransactionFromJson(json.value).._id = json.key;

  @override
  Map<String, dynamic> toJson() => _$SetBalanceTransactionToJson(this);

  Transaction copyWith(
      {double? sum,
        TransactionType? transactionType,
        String? categoryId,
        String? accountId,
        DateTime? time,
        DateTime? creationTime,
        String? comment}) {
    return SetBalanceTransaction(
      sum: sum ?? this.sum,
      transactionType: transactionType ?? this.transactionType,
      accountId: accountId ?? this.accountId,
      time: time ?? this.time,
      creationTime: creationTime ?? this.creationTime,
    ).._id = _id;
  }

}

@JsonSerializable()
class TransferTransaction extends Transaction {
  final String toAccountId;

  TransferTransaction({
    required super.sum,
    required super.transactionType,
    required super.accountId,
    required super.time,
    required super.creationTime,
    required this.toAccountId,
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
          toAccountId == other.toAccountId;

  @override
  int get hashCode => super.hashCode ^ toAccountId.hashCode;

  Transaction copyWith(
      {double? sum,
        TransactionType? transactionType,
        String? categoryId,
        String? accountId,
        String? toAccountId,
        DateTime? time,
        DateTime? creationTime,
        String? comment}) {
    return TransferTransaction(
      sum: sum ?? this.sum,
      transactionType: transactionType ?? this.transactionType,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      time: time ?? this.time,
      creationTime: creationTime ?? this.creationTime,
      comment: comment ?? this.comment,
    ).._id = _id;
  }

}
