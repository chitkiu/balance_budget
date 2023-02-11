import '../../../common/data/models/budget_id.dart';

abstract class BudgetUIModel {
  final String name;
  final BudgetId id;

  BudgetUIModel(this.name, this.id);
}

class TotalBudgetUIModel extends BudgetUIModel {
  final double totalSum;
  final double spendSum;

  TotalBudgetUIModel(super.name, super.id, this.totalSum, this.spendSum);

}
