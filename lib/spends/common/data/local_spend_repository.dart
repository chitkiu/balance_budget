import 'package:balance_budget/accounts/common/data/local_account_repository.dart';
import 'package:balance_budget/accounts/common/data/models/account_id.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category_id.dart';
import 'models/spend.dart';
import 'models/spend_id.dart';

class LocalSpendRepository {
  final _uuid = const Uuid();
  final RxList<Spend> spends = <Spend>[].obs;

  //TODO Remove after add normal storage
  LocalSpendRepository() {
    LocalCategoryRepository category = Get.find();
    var allCategories = category.categories;
    LocalAccountRepository accountRepository = Get.find();
    var allAccounts = accountRepository.accounts;
    create(
        1.1,
        allCategories[0].id,
        allAccounts[0].id,
        DateTime.now(),
        null
    );
    create(
        1.2,
        allCategories[0].id,
        allAccounts[0].id,
        DateTime.now(),
        null
    );
    create(
        2.2,
        allCategories[1].id,
        allAccounts[1].id,
        DateTime.now().subtract(const Duration(days: 2)),
        null
    );
    create(
        2.3,
        allCategories[0].id,
        allAccounts[1].id,
        DateTime.now().subtract(const Duration(days: 2)),
        null
    );
  }

  void create(double sum, CategoryId categoryId, AccountId accountId, DateTime time, String? comment) {
    spends.add(Spend(
      id: SpendId(_uuid.v4()),
      sum: sum,
      categoryId: categoryId,
      accountId: accountId,
      time: time,
      comment: comment,
    ));
  }

  void remove(SpendId spend) {
    spends.removeWhere((element) => element.id == spend);
  }

  void edit(SpendId spend, double? sum, CategoryId? categoryId, DateTime? time, String? comment) {
    var editSpend =
        spends.firstWhereOrNull((element) => element.id == spend);
    if (editSpend == null) {
      return;
    }
    var index = spends.lastIndexOf(editSpend);

    spends.removeAt(index);

    spends.insert(index, editSpend.copyWith(sum: sum, categoryId: categoryId, time: time, comment: comment));
  }
}
