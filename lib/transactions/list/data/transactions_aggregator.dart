import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../accounts/common/data/local_account_repository.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../common/data/local_transactions_repository.dart';
import 'models/rich_transaction_model.dart';

class TransactionsAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();

  LocalTransactionsRepository get _transactionsRepository => Get.find();

  LocalAccountRepository get _accountRepository => Get.find();

  const TransactionsAggregator();

  Stream<List<RichTransactionModel>> transactions() {
    return CombineLatestStream.combine3(
      _categoryRepository.categories,
      _transactionsRepository.transactions,
      _accountRepository.accounts,
      (categories, transactions, accounts) {
        List<RichTransactionModel> newTransactions = transactions
            .map((transaction) {
              var category =
                  categories.firstWhereOrNull((element) => element.id == transaction.categoryId);
              if (category == null && transaction.transactionType != TransactionType.transfer) {
                return null;
              }

              var account =
                  accounts.firstWhereOrNull((element) => element.id == transaction.accountId);
              if (account == null) {
                return null;
              }

              if (transaction.transactionType == TransactionType.transfer) {
                assert(transaction.additionalData != null);
                var toAccount = accounts.firstWhereOrNull((element) => element.id == transaction.additionalData);
                assert(toAccount != null);
                var category = categories.firstWhereOrNull((element) => element.transactionType == TransactionType.transfer);
                assert(category != null);
                return RichTransferTransactionModel(transaction, category!, account, toAccount!);
              }

              return RichTransactionModel(transaction, category!, account);
            })
            .where((element) => element != null)
            .map((e) => e!)
            .toList();

        newTransactions.sort(_compare);

        return newTransactions;
      },
    );
  }

  int _compare(RichTransactionModel a, RichTransactionModel b) {
    var result = b.transaction.time.compareTo(a.transaction.time);
    if (result == 0) {
      return b.transaction.creationTime.compareTo(a.transaction.creationTime);
    }
    return result;
  }
}
