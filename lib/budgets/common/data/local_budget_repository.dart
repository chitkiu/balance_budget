import 'package:balance_budget/budgets/common/data/models/budget_date.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../accounts/common/data/models/account_id.dart';
import 'models/budget.dart';
import 'models/budget_id.dart';
import 'models/budget_repeat_type.dart';

class LocalBudgetRepository {
  Uuid get _uuid => Get.find();
  RxList<Budget> budgets = <Budget>[].obs;

  LocalBudgetRepository() {
    createTotalBudget(
        BudgetRepeatType.oneTime,
        BudgetRepeatType.oneTime.name,
        1000,
      startDate: const BudgetDate(year: 2023, month: 2, day: 8),
      endDate: const BudgetDate(year: 2023, month: 2, day: 9),
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
}
