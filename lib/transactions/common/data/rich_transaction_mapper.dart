import 'package:balance_budget/transactions/common/data/rich_transaction_comparator.dart';
import 'package:collection/collection.dart';

import '../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../../wallets/common/data/models/wallet.dart';
import 'models/rich_transaction_model.dart';
import 'models/transaction.dart';

class RichTransactionMapper {
  final RichTransactionComparator _comparator;

  const RichTransactionMapper(this._comparator);

  List<RichTransactionModel> mapTransactions(List<Category> categories,
      List<Transaction> transactions, List<Wallet> wallets) {
    List<RichTransactionModel> newTransactions = transactions
        .map((transaction) => mapTransaction(categories, transaction, wallets))
        .whereNotNull()
        .toList();

    newTransactions.sort(_comparator.compare);

    return newTransactions;
  }

  RichTransactionModel? mapTransaction(List<Category> categories,
      Transaction? transaction, List<Wallet> wallets) {
    if (transaction == null) {
      return null;
    }
    var wallet = wallets
        .firstWhereOrNull((element) => element.id == transaction.walletId);
    if (wallet == null) {
      return null;
    }
    switch (transaction.transactionType) {
      case TransactionType.setInitialBalance:
        return InitialBalanceRichTransactionModel(transaction, wallet);
      case TransactionType.transfer:
        if (transaction is TransferTransaction) {
          var toWallet = wallets.firstWhereOrNull(
              (element) => element.id == transaction.toWalletId);
          if (toWallet == null) {
            return null;
          }
          return TransferRichTransactionModel(
            transaction,
            wallet,
            toWallet,
          );
        } else {
          return null;
        }
      case TransactionType.expense:
      case TransactionType.income:
        if (transaction is CommonTransaction) {
          var category = categories.firstWhereOrNull(
              (element) => element.id == transaction.categoryId);
          if (category == null) {
            return null;
          }
          return CategoryRichTransactionModel(transaction, wallet, category);
        } else {
          return null;
        }
    }
  }

  List<RichTransactionModel> mapTransactionsWithPresetCategory(Category? category, List<Transaction> transactions, List<Wallet> wallets) {
    List<RichTransactionModel> newTransactions = transactions
        .map((transaction) {
          var wallet = wallets
              .firstWhereOrNull((element) => element.id == transaction.walletId);
          if (wallet == null) {
            return null;
          }
          if (category == null) {
            return null;
          }
          return CategoryRichTransactionModel(transaction, wallet, category);
        })
        .whereNotNull()
        .toList();

    newTransactions.sort(_comparator.compare);

    return newTransactions;
  }
}
