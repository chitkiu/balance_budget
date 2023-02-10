
import '../../../../accounts/common/data/models/account_id.dart';
import '../../../../categories/common/data/models/category_id.dart';
import '../../../../common/data/models/transaction_type.dart';
import 'transaction_id.dart';

class Transaction {
  final TransactionId id;
  final double sum;
  final TransactionType transactionType;
  final CategoryId categoryId;
  final AccountId accountId;
  final DateTime time;
  final String? comment;

  Transaction(
      {required this.id,
      required this.sum,
      required this.transactionType,
      required this.categoryId,
      required this.accountId,
      required this.time,
      this.comment});

  Transaction copyWith({double? sum, TransactionType? transactionType, CategoryId? categoryId, AccountId? accountId, DateTime? time, String? comment}) {
    return Transaction(
      id: this.id,
      sum: sum ?? this.sum,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      time: time ?? this.time,
      comment: comment ?? this.comment,
    );
  }

  @override
  String toString() {
    return 'Spend{id: $id, sum: $sum, transactionType: $transactionType, categoryId: $categoryId, accountId: $accountId, time: $time, comment: $comment}';
  }
}
