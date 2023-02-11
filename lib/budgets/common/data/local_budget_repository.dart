import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../accounts/common/data/models/account_id.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category_id.dart';
import '../../../common/data/models/transaction_type.dart';
import 'models/budget.dart';
import 'models/budget_date.dart';
import 'models/budget_id.dart';
import 'models/budget_repeat_type.dart';

class LocalBudgetRepository {
  Uuid get _uuid => Get.find();
  RxList<Budget> budgets = <Budget>[].obs;

  //TODO Remove after add normal storage
  LocalBudgetRepository() {
    createTotalBudget(
      BudgetRepeatType.oneTime,
      BudgetRepeatType.oneTime.name,
      1000,
      startDate: const BudgetDate(year: 2023, month: 2, day: 8),
      endDate: const BudgetDate(year: 2023, month: 2, day: 9),
    );

    LocalCategoryRepository category = Get.find();
    var categories =
        category.categories.where((p0) => p0.transactionType == TransactionType.spend).toList();

    createCategoryBudget(
      BudgetRepeatType.oneTime,
      BudgetRepeatType.oneTime.name,
      1000,
      categories.first.id,
      startDate: const BudgetDate(year: 2023, month: 2, day: 8),
    );

    createTotalBudgetWithCategories(
      BudgetRepeatType.oneTime,
      BudgetRepeatType.oneTime.name,
      [
        createCategoryInfo(categories.first.id, 500),
        createCategoryInfo(categories[1].id, 1000),
      ],
      // startDate: const BudgetDate(year: 2023, month: 2, day: 8),
    );
  }

  void createTotalBudget(
    BudgetRepeatType repeatType,
    String name,
    double totalSum, {
    BudgetDate? startDate,
    BudgetDate? endDate,
    List<AccountId>? accounts,
  }) {
    budgets.add(TotalBudget(BudgetId(_uuid.v4()), name, repeatType,
        startDate ?? BudgetDate.fromNow(), endDate, totalSum, accounts ?? []));
  }

  void createCategoryBudget(
    BudgetRepeatType repeatType,
    String name,
    double maxSum,
    CategoryId categoryId, {
    BudgetDate? startDate,
    BudgetDate? endDate,
    List<AccountId>? accounts,
  }) {
    budgets.add(CategoryBudget(
      BudgetId(_uuid.v4()),
      name,
      repeatType,
      startDate ?? BudgetDate.fromNow(),
      endDate,
      createCategoryInfo(categoryId, maxSum, accounts: accounts),
    ));
  }

  void createTotalBudgetWithCategories(
    BudgetRepeatType repeatType,
    String name,
    List<CategoryBudgetInfo> categories, {
    BudgetDate? startDate,
    BudgetDate? endDate,
  }) {
    budgets.add(TotalBudgetWithCategories(
      BudgetId(_uuid.v4()),
      name,
      repeatType,
      startDate ?? BudgetDate.fromNow(),
      endDate,
      categories,
    ));
  }

  CategoryBudgetInfo createCategoryInfo(CategoryId categoryId, double maxSum,
      {List<AccountId>? accounts}) {
    return CategoryBudgetInfo(
        categoryId: categoryId, maxSum: maxSum, accounts: accounts ?? []);
  }
}
