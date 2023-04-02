import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../../wallets/common/data/models/wallet.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/transaction.dart';
import 'models/rich_transaction_model.dart';

class TransactionsAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();

  LocalTransactionsRepository get _transactionsRepository => Get.find();

  LocalWalletRepository get _walletRepository => Get.find();

  const TransactionsAggregator();

  //TODO Add filters
  Stream<List<RichTransactionModel>> transactions() {
    return CombineLatestStream.combine3(
      _categoryRepository.categories,
      _transactionsRepository.transactions,
      _walletRepository.wallets,
      _mapTransactions,
    );
  }

  Stream<List<RichTransactionModel>> transactionsByDate(
      DateTime start,
      DateTime end,
  ) {
    return CombineLatestStream.combine3(
      _categoryRepository.categories,
      _transactionsRepository.getTransactionByTimeRange(start, end),
      _walletRepository.wallets,
      _mapTransactions,
    );
  }

  int compare(RichTransactionModel a, RichTransactionModel b) {
    var result = b.transaction.time.compareTo(a.transaction.time);
    if (result == 0) {
      return b.transaction.creationTime.compareTo(a.transaction.creationTime);
    }
    return result;
  }

  List<RichTransactionModel> _mapTransactions(
      List<Category> categories, List<Transaction> transactions, List<Wallet> wallets) {
    List<RichTransactionModel> newTransactions = transactions
        .map((transaction) {
          var wallet =
              wallets.firstWhereOrNull((element) => element.id == transaction.walletId);
          if (wallet == null) {
            return null;
          }
          switch (transaction.transactionType) {
            case TransactionType.setInitialBalance:
              return null;
            case TransactionType.transfer:
              if (transaction is TransferTransaction) {
                var toWallet = wallets
                    .firstWhereOrNull((element) => element.id == transaction.toWalletId);
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
                var category = categories
                    .firstWhereOrNull((element) => element.id == transaction.categoryId);
                if (category == null) {
                  return null;
                }
                return CategoryRichTransactionModel(transaction, wallet, category);
              } else {
                return null;
              }
          }
        })
        .whereNotNull()
        .toList();

    newTransactions.sort(compare);

    return newTransactions;
  }
}
