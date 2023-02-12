import 'budget_date.dart';
import 'budget_id.dart';
import 'budget_repeat_type.dart';

abstract class Budget {
  final BudgetId id;
  final String name;
  final BudgetRepeatType repeatType;
  final BudgetDate startDate;
  final BudgetDate? endDate;

  Budget(this.id, this.name, this.repeatType, this.startDate, this.endDate);

  double get totalSum;
}

class CategoryBudget extends Budget {
  final CategoryBudgetInfo categoryInfo;

  CategoryBudget(
      super.id,
      super.name,
      super.repeatType,
      super.startDate,
      super.endDate,
      this.categoryInfo,
  );

  @override
  double get totalSum => categoryInfo.maxSum;
}

class TotalBudgetWithCategories extends Budget {
  final List<CategoryBudgetInfo> categoriesInfo;

  TotalBudgetWithCategories(
      super.id,
      super.name,
      super.repeatType,
      super.startDate,
      super.endDate,
      this.categoriesInfo,
  );

  @override
  double get totalSum {
    var totalSum = 0.0;
    for (var element in categoriesInfo) {
      totalSum += element.maxSum;
    }
    return totalSum;
  }
}

class TotalBudget extends Budget {
  @override
  final double totalSum;

  final List<String> accounts;

  TotalBudget(
      super.id,
      super.name,
      super.repeatType,
      super.startDate,
      super.endDate,
      this.totalSum,
      this.accounts
  );
}

class CategoryBudgetInfo {
  final String categoryId;
  final double maxSum;
  final List<String> accounts;

  CategoryBudgetInfo({required this.categoryId, required this.maxSum, required this.accounts});
}
