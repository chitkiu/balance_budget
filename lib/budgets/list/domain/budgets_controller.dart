import 'dart:async';

import 'package:get/get.dart';

import '../../common/data/local_budget_repository.dart';
import '../data/budget_aggregator.dart';
import '../ui/models/budget_ui_model.dart';
import 'mappers/budget_ui_mapper.dart';

class BudgetsController extends GetxController {
  LocalBudgetRepository get _budgetRepo => Get.find();

  BudgetAggregator get _budgetAggregator => Get.find();

  final BudgetUIMapper _mapper = const BudgetUIMapper();

  RxList<BudgetUIModel> budgets = <BudgetUIModel>[].obs;
  StreamSubscription? _listener;

  @override
  void onReady() {
    _listener?.cancel();
    _listener = _budgetAggregator.budgets().listen((value) {
      budgets.value =
          value.map((e) => _mapper.map(e)).whereType<BudgetUIModel>().toList();
    });

    _budgetRepo.budgets.refresh();

    super.onReady();
  }

  @override
  void onClose() {
    _listener?.cancel();
    _listener = null;
    super.onClose();
  }

  void onAddClick() {
    // Get.to(
    //       () => AddAccountScreen(),
    //   binding: AddAccountBinding(),
    // );
  }
}
