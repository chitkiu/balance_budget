import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../categories/common/data/models/category.dart';
import '../../../../transactions/common/data/models/rich_transaction_model.dart';
import '../../../../transactions/common/data/models/transaction.dart';
import '../../../../wallets/common/data/models/wallet.dart';
import '../../../data/models/transaction_type.dart';
import '../../common_ui_settings.dart';
import '../models/transaction_header_ui_model.dart';
import '../models/transaction_ui_model.dart';

class TransactionsUIMapper {
  final NumberFormat _sumFormatter = NumberFormat("##0.00");
  final DateFormat _headerDateFormat = DateFormat("dd MMMM");

  TransactionUIModel? mapFromRich(RichTransactionModel richTransaction) {
    switch (richTransaction.runtimeType) {
      case TransferRichTransactionModel:
        TransferRichTransactionModel transaction =
            richTransaction as TransferRichTransactionModel;
        return _mapTransferModel(transaction.transaction,
            transaction.fromWallet, transaction.toWallet);

      case CategoryRichTransactionModel:
        CategoryRichTransactionModel transaction =
            richTransaction as CategoryRichTransactionModel;
        return _mapCommonModel(transaction.transaction, transaction.category,
            transaction.fromWallet);
    }

    return null;
  }

  TransactionHeaderUIModel mapHeader(
      DateTime date,
      Iterable<RichTransactionModel> transactions,
      Iterable<TransactionUIModel> transactionsUIModel) {
    final expenseSum = transactions
        .where((element) =>
            element.transaction.transactionType == TransactionType.expense)
        .map((e) => e.transaction.sum)
        .sum;
    final incomeSum = transactions
        .where((element) =>
            element.transaction.transactionType == TransactionType.income)
        .map((e) => e.transaction.sum)
        .sum;
    final totalSum = incomeSum - expenseSum;
    String totalSumText = _sumFormatter.format(totalSum.abs());
    Color sumColor = Colors.grey;
    if (totalSum < 0) {
      totalSumText = "-$totalSumText";
      sumColor = Colors.redAccent;
    } else if (totalSum > 0) {
      totalSumText = "+$totalSumText";
      sumColor = Colors.green;
    }
    return TransactionHeaderUIModel(
      _headerDateFormat.format(date),
      totalSumText,
      sumColor,
      transactionsUIModel,
    );
  }

  TransactionUIModel _mapCommonModel(
      Transaction transaction, Category category, Wallet wallet) {
    return CommonTransactionUIModel(
      id: transaction.id,
      sum: _sumFormat(transaction.sum),
      sumDouble: transaction.sum,
      sumColor: (transaction.transactionType == TransactionType.expense)
          ? Colors.redAccent
          : Colors.green,
      categoryName: category.title,
      walletName: wallet.name,
      formattedDate: _dateFormat(transaction.time),
      dateTime: transaction.time,
      comment: transaction.comment,
      icon: category.icon,
    );
  }

  TransactionUIModel _mapTransferModel(
    Transaction transaction,
    Wallet fromWallet,
    Wallet toWallet,
  ) {
    return TransferTransactionUIModel(
      id: transaction.id,
      sum: _sumFormat(transaction.sum),
      sumDouble: transaction.sum,
      fromWalletName: fromWallet.name,
      toWalletName: toWallet.name,
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
