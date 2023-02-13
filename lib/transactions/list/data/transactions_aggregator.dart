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
        return transactions
            .map((e) {
              var category =
                  categories.firstWhereOrNull((element) => element.id == e.categoryId);
              if (category == null) {
                category =
                    categories.firstWhereOrNull((element) => element.transactionType == e.transactionType);
                if (category == null) {
                  return null;
                }
              }

              var account =
                  accounts.firstWhereOrNull((element) => element.id == e.accountId);
              if (account == null) {
                return null;
              }

              return RichTransactionModel(e, category, account);
            })
            .whereType<RichTransactionModel>()
            .toList();
      },
    );
  }
}
