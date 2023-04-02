abstract class BudgetUIModel {
  final String name;
  final String id;

  BudgetUIModel(this.name, this.id);
}

class TotalBudgetUIModel extends BudgetUIModel {
  final double totalSum;
  final double expenseSum;

  TotalBudgetUIModel(super.name, super.id, this.totalSum, this.expenseSum);
}

class CategoryInfoUIModel {
  final double totalSum;
  final double expenseSum;
  final String categoryName;

  CategoryInfoUIModel(this.totalSum, this.expenseSum, this.categoryName);
}

class CategoryBudgetUIModel extends BudgetUIModel {
  final CategoryInfoUIModel categoryInfoUIModel;

  CategoryBudgetUIModel(super.name, super.id, this.categoryInfoUIModel);
}

class TotalBudgetWithCategoryUIModel extends BudgetUIModel {
  final double totalSum;
  final double expenseSum;
  final List<CategoryInfoUIModel> categoriesInfoUIModel;

  TotalBudgetWithCategoryUIModel(
      super.name, super.id, this.totalSum, this.expenseSum, this.categoriesInfoUIModel);
}
