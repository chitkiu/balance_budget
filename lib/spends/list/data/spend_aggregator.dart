import 'package:balance_budget/accounts/common/data/local_account_repository.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../common/data/local_spend_repository.dart';
import 'models/rich_spend_model.dart';

class SpendAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();
  LocalSpendRepository get _spendRepository => Get.find();
  LocalAccountRepository get _accountRepository => Get.find();

  const SpendAggregator();

  Stream<List<RichSpendModel>> spends() {
    return CombineLatestStream.combine3(
      _categoryRepository.categories.stream,
      _spendRepository.spends.stream,
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

              return RichSpendModel(e, category, account);
            })
            .whereType<RichSpendModel>()
            .toList();
      },
    );
  }
}
