import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../accounts/common/data/local_account_repository.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/transaction.dart';
import 'models/rich_transaction_model.dart';

class TransactionsAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();

  LocalTransactionsRepository get _transactionsRepository => Get.find();

  LocalAccountRepository get _accountRepository => Get.find();

  const TransactionsAggregator();

  //TODO Add filters
  Stream<List<RichTransactionModel>> transactions() {
    return CombineLatestStream.combine3(
      _categoryRepository.categories,
      _transactionsRepository.transactions,
      _accountRepository.accounts,
      (categories, transactions, accounts) {
        List<RichTransactionModel> newTransactions = transactions
            .map((transaction) {
          var account =
          accounts.firstWhereOrNull((element) => element.id == transaction.accountId);
          if (account == null) {
            return null;
          }
          switch (transaction.transactionType) {
            case TransactionType.setInitialBalance:
              return null;
            case TransactionType.transfer:
              if (transaction is TransferTransaction) {
                var toAccount = accounts.firstWhereOrNull(
                        (element) => element.id == transaction.toAccountId
                );
                if (toAccount == null) {
                  return null;
                }
                return TransferRichTransactionModel(
                  transaction,
                  account,
                  toAccount,
                );
              } else {
                return null;
              }
            case TransactionType.spend:
            case TransactionType.income:
              if (transaction is CommonTransaction) {
                var category = categories.firstWhereOrNull((element) =>
                element.id == transaction.categoryId);
                if (category == null) {
                  return null;
                }
                return CategoryRichTransactionModel(
                    transaction, account, category
                );
              } else {
                return null;
              }
          }
        })
            .whereNotNull()
            .toList();

        newTransactions.sort(compare);

        return newTransactions;
      },
    );
  }

  int compare(RichTransactionModel a, RichTransactionModel b) {
    var result = b.transaction.time.compareTo(a.transaction.time);
    if (result == 0) {
      return b.transaction.creationTime.compareTo(a.transaction.creationTime);
    }
    return result;
  }
}
