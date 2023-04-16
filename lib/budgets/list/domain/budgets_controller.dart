import 'dart:async';

import 'package:get/get.dart';

import '../../add/domain/add_budget_binding.dart';
import '../../add/ui/add_budget_screen.dart';
import '../../common/data/local_budget_repository.dart';
import '../data/budget_aggregator.dart';
import '../ui/models/budget_ui_model.dart';
import 'mappers/budget_ui_mapper.dart';

class BudgetsController extends GetxController {
  LocalBudgetRepository get _budgetRepo => Get.find();

  BudgetAggregator get _budgetAggregator => Get.find();

  final BudgetUIMapper _mapper = const BudgetUIMapper();

  Stream<List<BudgetUIModel>> getBudgets() {
    return _budgetAggregator.budgets().map((value) {
      return value.map((e) => _mapper.map(e))
          .whereType<BudgetUIModel>()
          .toList();
    });
  }

  void onAddClick() {
    Get.to(
          () => AddBudgetScreen(),
      binding: AddBudgetBinding(),
    );
  }
}
