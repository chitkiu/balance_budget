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
      _categoryRepository.categories.stream,
      _transactionsRepository.transactions.stream,
      _accountRepository.accounts.stream,
      (categories, spends, accounts) {
        return spends
            .map((e) {
              var category = categories
                  .firstWhereOrNull((element) => element.id == e.categoryId);
              if (category == null) {
                return null;
              }

              var account = accounts
                  .firstWhereOrNull((element) => element.id == e.accountId);
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
