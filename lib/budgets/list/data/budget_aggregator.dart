import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../accounts/common/data/local_account_repository.dart';
import '../../../accounts/common/data/models/account.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../../transactions/common/data/models/transaction.dart';
import '../../common/data/local_budget_repository.dart';
import '../../common/data/models/budget.dart';
import '../../common/data/models/budget_date.dart';
import '../../common/data/models/budget_repeat_type.dart';
import '../../common/data/models/category_budget_info.dart';
import '../domain/calculators/date_period_validation.dart';
import 'models/rich_budget.dart';

class BudgetAggregator {
  LocalTransactionsRepository get _transactionRepo => Get.find();

  LocalAccountRepository get _accountRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalBudgetRepository get _budgetRepo => Get.find();

  final DatePeriodValidation _periodValidation = const DatePeriodValidation();

  const BudgetAggregator();

  Stream<List<RichBudget>> budgets() {
    return CombineLatestStream.combine4(
        _transactionRepo.transactions,
        _accountRepo.accounts,
        _categoryRepo.categories,
        _budgetRepo.budgets, (transactions, accounts, categories, budgets) {
      return budgets
          .map((budget) {
            if (budget is TotalBudget) {
              return _mapToTotal(budget, transactions, accounts);
            } else if (budget is CategoryBudget) {
              return _mapSingleCategoryRichBudget(
                  budget, categories, transactions, accounts);
            } else if (budget is TotalBudgetWithCategories) {
              return _mapTotalRichBudgetWithCategory(
                  budget, categories, transactions, accounts);
            } else {
              return null;
            }
          })
          .whereType<RichBudget>()
          .toList();
    });
  }

  RichBudget _mapToTotal(
      TotalBudget budget, List<Transaction> transactions, List<Account> accounts) {
    var filteredTransaction = transactions.where((element) {
      return element.transactionType == TransactionType.spend &&
          _periodValidation.isInCurrentPeriod(
              element.time, budget.repeatType, budget.startDate, budget.endDate) &&
          _isCorrectAccount(budget.accounts, element.accountId);
    });

    var filteredAccounts = accounts;
    if (budget.accounts.isNotEmpty) {
      filteredAccounts =
          accounts.where((element) => budget.accounts.contains(element.id)).toList();
    }

    return RichTotalBudget(
      budget,
      filteredTransaction,
      filteredAccounts,
    );
  }

  RichBudget _mapSingleCategoryRichBudget(CategoryBudget budget,
      List<Category> categories, List<Transaction> transactions, List<Account> accounts) {
    return RichCategoryBudget(
        budget,
        _mapCategoryInfo(
          budget.categoryInfo,
          budget.repeatType,
          budget.startDate,
          budget.endDate,
          categories,
          transactions,
          accounts,
        ));
  }

  RichBudget _mapTotalRichBudgetWithCategory(TotalBudgetWithCategories budget,
      List<Category> categories, List<Transaction> transactions, List<Account> accounts) {
    return RichTotalBudgetWithCategory(
        budget,
        budget.categoriesInfo.map((categoryInfo) {
          return _mapCategoryInfo(
            categoryInfo,
            budget.repeatType,
            budget.startDate,
            budget.endDate,
            categories,
            transactions,
            accounts,
          );
        }).toList());
  }

  RichCategoryBudgetInfo _mapCategoryInfo(
      CategoryBudgetInfo categoryInfo,
      BudgetRepeatType repeatType,
      BudgetDate startDate,
      BudgetDate? endDate,
      List<Category> categories,
      List<Transaction> transactions,
      List<Account> accounts) {

    var filteredTransaction = transactions.where((element) {
      return element is CommonTransaction &&
          element.transactionType == TransactionType.spend &&
          element.categoryId == categoryInfo.categoryId &&
          _periodValidation.isInCurrentPeriod(
              element.time, repeatType, startDate, endDate) &&
          _isCorrectAccount(categoryInfo.accounts, element.accountId);
    });

    var filteredAccounts = accounts;
    if (categoryInfo.accounts.isNotEmpty) {
      filteredAccounts = accounts
          .where((element) => categoryInfo.accounts.contains(element.id))
          .toList();
    }

    var totalSpendSum = 0.0;
    for (var value in filteredTransaction) {
      totalSpendSum += value.sum;
    }

    return RichCategoryBudgetInfo(
      categoryInfo.maxSum,
      totalSpendSum,
      categories.firstWhere((element) => element.id == categoryInfo.categoryId),
      filteredAccounts,
      filteredTransaction,
    );
  }

  bool _isCorrectAccount(List<String> accounts, String id) {
    return accounts.isEmpty || accounts.contains(id);
  }
}
