import 'package:json_annotation/json_annotation.dart';

import '../../../../common/data/models/epoch_date_time_converter.dart';
import '../../../../common/data/models/transaction_type.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  @JsonKey(includeFromJson: false)
  String? _id;
  final double sum;
  final TransactionType transactionType;
  final String? categoryId;
  final String accountId;
  @EpochDateTimeConverter()
  final DateTime time;
  @EpochDateTimeConverter()
  final DateTime creationTime;
  final String? comment;
  ///Added for some custom data, which can be only in some transaction
  ///For example like transfer between wallets
  final String? additionalData;

  String get id => _id ?? '';

  Transaction(
      {required this.sum,
      required this.transactionType,
      this.categoryId,
      required this.accountId,
      required this.time,
      required this.creationTime,
      this.comment,
      this.additionalData});

  factory Transaction.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$TransactionFromJson(json.value).._id = json.key;

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  Transaction copyWith(
      {double? sum,
      TransactionType? transactionType,
      String? categoryId,
      String? accountId,
      DateTime? time,
      DateTime? creationTime,
      String? comment,
      String? additionalData}) {
    var finalComment = this.comment;
    if (comment == '') {
      finalComment = null;
    } else if (comment?.isNotEmpty == true) {
      finalComment = comment;
    }
    return Transaction(
      sum: sum ?? this.sum,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      time: time ?? this.time,
      comment: finalComment,
      creationTime: creationTime ?? this.creationTime,
      additionalData: additionalData ?? this.additionalData,
    ).._id = _id;
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          sum == other.sum &&
          transactionType == other.transactionType &&
          categoryId == other.categoryId &&
          accountId == other.accountId &&
          time == other.time &&
          creationTime == other.creationTime &&
          comment == other.comment &&
          additionalData == other.additionalData;

  @override
  int get hashCode =>
      _id.hashCode ^
      sum.hashCode ^
      transactionType.hashCode ^
      categoryId.hashCode ^
      accountId.hashCode ^
      time.hashCode ^
      creationTime.hashCode ^
      comment.hashCode ^
      additionalData.hashCode;

  @override
  String toString() {
    return 'Transaction{_id: $_id, sum: $sum, transactionType: $transactionType, categoryId: $categoryId, accountId: $accountId, time: $time, creationTime: $creationTime, comment: $comment, additionalData: $additionalData}';
  }
}
