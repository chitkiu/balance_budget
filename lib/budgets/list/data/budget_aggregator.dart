import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../../transactions/common/data/models/transaction.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../../wallets/common/data/models/wallet.dart';
import '../../common/data/local_budget_repository.dart';
import '../../common/data/models/budget.dart';
import '../../common/data/models/budget_repeat_type.dart';
import '../../common/data/models/category_budget_info.dart';
import '../domain/calculators/date_period_validation.dart';
import 'models/rich_budget.dart';

class BudgetAggregator {
  LocalTransactionsRepository get _transactionRepo => Get.find();

  LocalWalletRepository get _walletRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalBudgetRepository get _budgetRepo => Get.find();

  final DatePeriodValidation _periodValidation = const DatePeriodValidation();

  const BudgetAggregator();

  Stream<List<RichBudget>> budgets() {
    return CombineLatestStream.combine4(
        _transactionRepo.transactions,
        _walletRepo.wallets,
        _categoryRepo.categories,
        _budgetRepo.budgets, (transactions, wallets, categories, budgets) {
      return budgets
          .map((budget) {
            if (budget is TotalBudget) {
              return _mapToTotal(budget, transactions, wallets);
            } else if (budget is CategoryBudget) {
              return _mapSingleCategoryRichBudget(
                  budget, categories, transactions, wallets);
            } else if (budget is MultiCategoryBudget) {
              return _mapTotalRichBudgetWithCategory(
                  budget, categories, transactions, wallets);
            } else {
              return null;
            }
          })
          .whereType<RichBudget>()
          .toList();
    });
  }

  RichBudget _mapToTotal(
      TotalBudget budget, List<Transaction> transactions, List<Wallet> wallets) {
    var filteredTransaction = transactions.where((element) {
      return element.transactionType == TransactionType.expense &&
          _periodValidation.isInCurrentPeriod(
              element.time, budget.repeatType, budget.startDate, budget.endDate) &&
          _isCorrectWallet(budget.wallets, element.walletId);
    });

    var filteredWallets = wallets;
    if (budget.wallets.isNotEmpty) {
      filteredWallets =
          wallets.where((element) => budget.wallets.contains(element.id)).toList();
    }

    return RichTotalBudget(
      budget,
      filteredTransaction,
      filteredWallets,
    );
  }

  RichBudget _mapSingleCategoryRichBudget(CategoryBudget budget,
      List<Category> categories, List<Transaction> transactions, List<Wallet> wallets) {
    return RichCategoryBudget(
        budget,
        _mapCategoryInfo(
          budget.categoryInfo,
          budget.repeatType,
          budget.startDate,
          budget.endDate,
          categories,
          transactions,
          wallets.where((value) => value.archived == false).toList(),
        ));
  }

  RichBudget _mapTotalRichBudgetWithCategory(MultiCategoryBudget budget,
      List<Category> categories, List<Transaction> transactions, List<Wallet> wallets) {
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
            wallets,
          );
        }).toList());
  }

  RichCategoryBudgetInfo _mapCategoryInfo(
      CategoryBudgetInfo categoryInfo,
      BudgetRepeatType repeatType,
      DateTime startDate,
      DateTime? endDate,
      List<Category> categories,
      List<Transaction> transactions,
      List<Wallet> wallets) {
    var filteredTransaction = transactions.where((element) {
      return element is CommonTransaction &&
          element.transactionType == TransactionType.expense &&
          element.categoryId == categoryInfo.categoryId &&
          wallets.any((wallet) => wallet.id == element.walletId) &&
          _periodValidation.isInCurrentPeriod(
              element.time, repeatType, startDate, endDate) &&
          _isCorrectWallet(categoryInfo.wallets, element.walletId);
    });

    var filteredWallets = wallets;
    if (categoryInfo.wallets.isNotEmpty) {
      filteredWallets = wallets
          .where((element) => categoryInfo.wallets.contains(element.id))
          .toList();
    }

    var totalExpendSum = 0.0;
    for (var value in filteredTransaction) {
      totalExpendSum += value.sum;
    }

    return RichCategoryBudgetInfo(
      categoryInfo.maxSum,
      totalExpendSum,
      categories.firstWhere((element) => element.id == categoryInfo.categoryId),
      filteredWallets,
      filteredTransaction,
    );
  }

  bool _isCorrectWallet(List<String> wallets, String id) {
    return wallets.isEmpty || wallets.contains(id);
  }
}
