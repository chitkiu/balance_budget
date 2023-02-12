abstract class BudgetUIModel {
  final String name;
  final String id;

  BudgetUIModel(this.name, this.id);
}

class TotalBudgetUIModel extends BudgetUIModel {
  final double totalSum;
  final double spendSum;

  TotalBudgetUIModel(super.name, super.id, this.totalSum, this.spendSum);
}

class CategoryInfoUIModel {
  final double totalSum;
  final double spendSum;
  final String categoryName;

  CategoryInfoUIModel(this.totalSum, this.spendSum, this.categoryName);
}

class CategoryBudgetUIModel extends BudgetUIModel {
  final CategoryInfoUIModel categoryInfoUIModel;

  CategoryBudgetUIModel(super.name, super.id, this.categoryInfoUIModel);
}

class TotalBudgetWithCategoryUIModel extends BudgetUIModel {
  final double totalSum;
  final double spendSum;
  final List<CategoryInfoUIModel> categoriesInfoUIModel;

  TotalBudgetWithCategoryUIModel(
      super.name, super.id, this.totalSum, this.spendSum, this.categoriesInfoUIModel);
}
