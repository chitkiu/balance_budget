import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../../common/ui/common_ui_settings.dart';
import '../../../common/data/models/transaction.dart';
import '../../data/models/rich_transaction_model.dart';
import '../../ui/models/transaction_ui_model.dart';

class TransactionsUIMapper {

  final NumberFormat _sumFormatter = NumberFormat("##0.00");

  TransactionUIModel map(Transaction transaction, Category category, Account fromAccount, Account? toAccount) {
    switch (transaction.transactionType) {
      case TransactionType.setInitialBalance:
        return _mapSetBalanceModel(transaction, category, fromAccount);
      case TransactionType.spend:
      case TransactionType.income:
        return _mapCommonModel(transaction, category, fromAccount);
      case TransactionType.transfer:
        assert(toAccount != null);
        return _mapTransferModel(transaction, category, fromAccount, toAccount!);
    }
  }

  TransactionUIModel _mapCommonModel(Transaction transaction, Category category, Account account) {
    return CommonTransactionUIModel(
      id: transaction.id,
      sum: _sumFormat(transaction.sum),
      sumDouble: transaction.sum,
      sumColor: (transaction.transactionType == TransactionType.spend) ? Colors.redAccent : Colors.green,
      categoryName: category.title,
      accountName: account.name,
      formattedDate: _dateFormat(transaction.time),
      dateTime: transaction.time,
      comment: transaction.comment,
    );
  }

  TransactionUIModel _mapSetBalanceModel(Transaction transaction, Category category, Account account) {
    return SetBalanceTransactionUIModel(
      id: transaction.id,
      sum: _sumFormat(transaction.sum),
      sumDouble: transaction.sum,
      accountName: account.name,
      formattedDate: _dateFormat(transaction.time),
      dateTime: transaction.time,
    );
  }

  TransactionUIModel _mapTransferModel(
      Transaction transaction,
      Category category,
      Account fromAccount,
      Account toAccount,
  ) {
    return TransferTransactionUIModel(
      id: transaction.id,
      sum: _sumFormat(transaction.sum),
      sumDouble: transaction.sum,
      fromAccountName: fromAccount.name,
      toAccountName: toAccount.name,
      formattedDate: _dateFormat(transaction.time),
      dateTime: transaction.time,
    );
  }

  TransactionUIModel mapFromRich(RichTransactionModel richTransaction) {
    if (richTransaction is RichTransferTransactionModel) {
      return map(richTransaction.transaction, richTransaction.category, richTransaction.account, richTransaction.toAccount);
    } else {
      return map(richTransaction.transaction, richTransaction.category, richTransaction.account, null);
    }
  }

  String _dateFormat(DateTime dateTime) {
    return CommonUI.dateFormatter.format(dateTime);
  }

  String _sumFormat(double sum) {
    return _sumFormatter.format(sum);
  }
}
