import 'package:balance_budget/accounts/common/data/local_account_repository.dart';
import 'package:balance_budget/accounts/common/data/models/account_id.dart';
import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category_id.dart';
import 'models/transaction.dart';
import 'models/transaction_id.dart';

class LocalTransactionsRepository {
  Uuid get _uuid => Get.find();

  final RxList<Transaction> transactions = <Transaction>[].obs;

  //TODO Remove after add normal storage
  LocalTransactionsRepository() {
    LocalCategoryRepository category = Get.find();
    var allCategories = category.categories;
    LocalAccountRepository accountRepository = Get.find();
    var allAccounts = accountRepository.accounts;
    create(
        1.1,
        TransactionType.spend,
        allCategories[0].id,
        allAccounts[0].id,
        DateTime.now(),
        null
    );
    create(
        1.2,
        TransactionType.spend,
        allCategories[0].id,
        allAccounts[0].id,
        DateTime.now(),
        null
    );
    create(
        2.2,
        TransactionType.spend,
        allCategories[1].id,
        allAccounts[1].id,
        DateTime.now().subtract(const Duration(days: 2)),
        null
    );
    create(
        2.3,
        TransactionType.spend,
        allCategories[0].id,
        allAccounts[1].id,
        DateTime.now().subtract(const Duration(days: 2)),
        null
    );
    create(
        100,
        TransactionType.income,
        allCategories[0].id,
        allAccounts[1].id,
        DateTime.now().subtract(const Duration(days: 3)),
        null
    );
  }

  void create(double sum, TransactionType transactionType, CategoryId categoryId, AccountId accountId, DateTime time, String? comment) {
    transactions.add(Transaction(
      id: TransactionId(_uuid.v4()),
      sum: sum,
      transactionType: transactionType,
      categoryId: categoryId,
      accountId: accountId,
      time: time,
      comment: comment,
    ));
  }

  void remove(TransactionId spend) {
    transactions.removeWhere((element) => element.id == spend);
  }

  void edit(TransactionId spend, double? sum, CategoryId? categoryId, DateTime? time, String? comment) {
    var editSpend =
        transactions.firstWhereOrNull((element) => element.id == spend);
    if (editSpend == null) {
      return;
    }
    var index = transactions.lastIndexOf(editSpend);

    transactions.removeAt(index);

    transactions.insert(index, editSpend.copyWith(sum: sum, categoryId: categoryId, time: time, comment: comment));
  }
}
