import '../../data/models/rich_budget.dart';
import '../../ui/models/budget_ui_model.dart';

class BudgetUIMapper {
  const BudgetUIMapper();

  BudgetUIModel? map(RichBudget richBudget) {
    if (richBudget is RichTotalBudget) {
      var totalExpenseSum = 0.0;
      for (var value in richBudget.transactions) {
        totalExpenseSum += value.sum;
      }
      return TotalBudgetUIModel(richBudget.budget.name, richBudget.budget.id,
          richBudget.budget.totalSum, totalExpenseSum);
    } else if (richBudget is RichCategoryBudget) {
      return CategoryBudgetUIModel(
        richBudget.budget.name,
        richBudget.budget.id,
        _mapCategoryInfo(richBudget.categoryBudgetInfo),
      );
    } else if (richBudget is RichTotalBudgetWithCategory) {
      var totalExpenseSum = 0.0;
      for (var category in richBudget.categories) {
        totalExpenseSum += category.totalExpenseSum;
      }

      return TotalBudgetWithCategoryUIModel(
          richBudget.budget.name,
          richBudget.budget.id,
          richBudget.budget.totalSum,
          totalExpenseSum,
          richBudget.categories.map(_mapCategoryInfo).toList(),
      );
    } else {
      return null;
    }
  }

  CategoryInfoUIModel _mapCategoryInfo(RichCategoryBudgetInfo categoryBudgetInfo) {
    return CategoryInfoUIModel(
      categoryBudgetInfo.totalSum,
      categoryBudgetInfo.totalExpenseSum,
      categoryBudgetInfo.category.title,
    );
  }
}
