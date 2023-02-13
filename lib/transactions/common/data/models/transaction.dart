import 'package:json_annotation/json_annotation.dart';

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
  final DateTime time;
  final String? comment;

  String get id => _id ?? '';

  Transaction(
      {required this.sum,
      required this.transactionType,
      this.categoryId,
      required this.accountId,
      required this.time,
      this.comment});

  factory Transaction.fromJson(MapEntry<dynamic, dynamic> json) =>
      _$TransactionFromJson(json.value).._id = json.key;

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  Transaction copyWith(
      {double? sum,
      TransactionType? transactionType,
      String? categoryId,
      String? accountId,
      DateTime? time,
      String? comment}) {
    return Transaction(
      sum: sum ?? this.sum,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      time: time ?? this.time,
      comment: comment ?? this.comment,
    ).._id = _id;
  }

  @override
  String toString() {
    return 'Transaction{id: $id, sum: $sum, transactionType: $transactionType, categoryId: $categoryId, accountId: $accountId, time: $time, comment: $comment}';
  }
}
