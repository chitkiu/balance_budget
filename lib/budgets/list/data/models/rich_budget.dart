import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../../transactions/common/data/models/transaction.dart';
import '../../../common/data/models/budget.dart';

abstract class RichBudget {
  final Budget budget;

  RichBudget(this.budget);
}

class RichCategoryBudgetInfo {
  final double totalSum;
  final double totalSpendSum;
  final Category category;
  final List<Account> account;
  final Iterable<Transaction> categoryTransactions;

  RichCategoryBudgetInfo(this.totalSum, this.totalSpendSum, this.category, this.account, this.categoryTransactions);
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
  final List<Account> account;

  RichTotalBudget(super.budget, this.transactions, this.account);
}


