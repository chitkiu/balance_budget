import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:flutter/material.dart';

import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction.dart';
import '../../data/models/rich_transaction_model.dart';
import '../../ui/models/transaction_ui_model.dart';

class TransactionsUIMapper {
  TransactionUIModel map(Transaction transaction, Category category, Account account) {
    switch (transaction.transactionType) {

      case TransactionType.setInitialBalance:
        return _mapSetBalanceModel(transaction, category, account);
      case TransactionType.spend:
      case TransactionType.income:
        return _mapCommonModel(transaction, category, account);
    }
  }

  TransactionUIModel _mapCommonModel(Transaction transaction, Category category, Account account) {
    return CommonTransactionUIModel(
      id: transaction.id,
      sum: transaction.sum.toString(),
      sumColor: (transaction.transactionType == TransactionType.spend) ? Colors.redAccent : Colors.green,
      categoryName: category.title,
      accountName: account.name,
      time: transaction.time.toString(),
      dateTime: transaction.time,
      comment: transaction.comment,
    );
  }

  TransactionUIModel _mapSetBalanceModel(Transaction transaction, Category category, Account account) {
    return SetBalanceTransactionUIModel(
      id: transaction.id,
      sum: transaction.sum.toString(),
      sumColor: (transaction.transactionType == TransactionType.spend) ? Colors.redAccent : Colors.green,
      accountName: account.name,
      time: transaction.time.toString(),
      dateTime: transaction.time,
    );
  }

  TransactionUIModel mapFromRich(RichTransactionModel richTransaction) {
    return map(richTransaction.transaction, richTransaction.category, richTransaction.account);
  }
}
