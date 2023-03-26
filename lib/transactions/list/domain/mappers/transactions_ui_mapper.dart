import 'package:balance_budget/transactions/list/ui/models/transaction_header_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../../common/data/models/transaction_type.dart';
import '../../../../common/ui/common_ui_settings.dart';
import '../../../common/data/models/transaction.dart';
import '../../data/models/rich_transaction_model.dart';
import '../../ui/models/transaction_ui_model.dart';

class TransactionsUIMapper {

  final NumberFormat _sumFormatter = NumberFormat("##0.00");
  final DateFormat _headerDateFormat = DateFormat("dd MMMM");

  TransactionUIModel? mapFromRich(RichTransactionModel richTransaction) {
    switch (richTransaction.runtimeType) {
      case TransferRichTransactionModel:
        TransferRichTransactionModel transaction = richTransaction as TransferRichTransactionModel;
        return _mapTransferModel(transaction.transaction, transaction.fromAccount, transaction.toAccount);

      case CategoryRichTransactionModel:
        CategoryRichTransactionModel transaction = richTransaction as CategoryRichTransactionModel;
        return _mapCommonModel(transaction.transaction, transaction.category, transaction.fromAccount);
    }

    return null;
  }

  ///TODO Transaction will be use later
  TransactionHeaderUIModel mapHeader(DateTime date, Iterable<TransactionUIModel> transactions) {
    return TransactionHeaderUIModel(
        _headerDateFormat.format(date)
    );
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

  TransactionUIModel _mapTransferModel(
      Transaction transaction,
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

  String _dateFormat(DateTime dateTime) {
    return CommonUI.dateFormatter.format(dateTime);
  }

  String _sumFormat(double sum) {
    return _sumFormatter.format(sum);
  }
}
