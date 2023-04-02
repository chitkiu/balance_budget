import '../../../../categories/common/data/models/category.dart';
import '../../../../transactions/common/data/models/transaction.dart';
import '../../../../wallets/common/data/models/wallet.dart';
import '../../../common/data/models/budget.dart';

abstract class RichBudget {
  final Budget budget;

  RichBudget(this.budget);
}

class RichCategoryBudgetInfo {
  final double totalSum;
  final double totalExpenseSum;
  final Category category;
  final List<Wallet> wallets;
  final Iterable<Transaction> categoryTransactions;

  RichCategoryBudgetInfo(this.totalSum, this.totalExpenseSum, this.category, this.wallets, this.categoryTransactions);
}

class RichCategoryBudget extends RichBudget {
  final RichCategoryBudgetInfo categoryBudgetInfo;

  RichCategoryBudget(super.budget, this.categoryBudgetInfo);
}

class RichTotalBudgetWithCategory extends RichBudget {
  final List<RichCategoryBudgetInfo> categories;

  RichTotalBudgetWithCategory(super.budget, this.categories);
}

class RichTotalBudget extends RichBudget {
  final Iterable<Transaction> transactions;
  final List<Wallet> wallets;

  RichTotalBudget(super.budget, this.transactions, this.wallets);
}


