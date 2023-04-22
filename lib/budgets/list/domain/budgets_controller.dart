import 'dart:async';

import 'package:collection/collection.dart';
import 'package:get/get.dart';

import '../../add/domain/add_budget_binding.dart';
import '../../add/ui/add_budget_screen.dart';
import '../data/budget_aggregator.dart';
import '../ui/models/budget_ui_model.dart';
import 'mappers/budget_ui_mapper.dart';

class BudgetsController extends GetxController with StateMixin<List<BudgetUIModel>> {
  BudgetAggregator get _budgetAggregator => Get.find();

  final BudgetUIMapper _mapper = const BudgetUIMapper();

  StreamSubscription? _budgetSubscription;

  @override
  void onInit() {
    super.onInit();

    _budgetSubscription ??= _getBudgets().handleError((Object e, StackTrace str) {
      change(null, status: RxStatus.error(str.toString()));
    }).listen((budgets) {
      if (budgets.isNotEmpty) {
        change(budgets, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    _budgetSubscription?.cancel();
    _budgetSubscription = null;
  }

  Stream<List<BudgetUIModel>> _getBudgets() {
    return _budgetAggregator.budgets().map((value) {
      return value.map((e) => _mapper.map(e)).whereNotNull().toList();
    });
  }

  void onAddClick() {
    Get.to(
      () => AddBudgetScreen(),
      binding: AddBudgetBinding(),
    );
  }
}
