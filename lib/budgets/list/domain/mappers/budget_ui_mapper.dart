import '../../../../transactions/common/data/models/transaction.dart';
import '../../../common/data/models/budget.dart';
import '../../ui/models/budget_ui_model.dart';
import '../calculators/total_budget_spend_sum_calculator.dart';

class BudgetUIMapper {

  final TotalBudgetSpendSumCalculator _totalBudgetSpendSumCalculator = const TotalBudgetSpendSumCalculator();

  const BudgetUIMapper();

  BudgetUIModel? map(Budget budget, List<Transaction> transactions) {
    if (budget is TotalBudget) {
      return TotalBudgetUIModel(
        budget.name,
        budget.id,
        budget.totalSum,
        _totalBudgetSpendSumCalculator.calculate(budget, transactions)
      );
    } else {
      return null;
    }
  }
}
