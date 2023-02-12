import 'dart:async';

import 'package:get/get.dart';

import '../../common/data/local_budget_repository.dart';
import '../../common/data/models/budget_date.dart';
import '../../common/data/models/budget_repeat_type.dart';
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

    super.onReady();
  }

  @override
  void onClose() {
    _listener?.cancel();
    _listener = null;
    super.onClose();
  }

  void onAddClick() {
    _budgetRepo.createTotalBudget(
      BudgetRepeatType.oneTime,
      BudgetRepeatType.oneTime.name,
      1000,
      startDate: const BudgetDate(year: 2023, month: 2, day: 8),
      endDate: const BudgetDate(year: 2023, month: 2, day: 9),
    );
    // Get.to(
    //       () => AddAccountScreen(),
    //   binding: AddAccountBinding(),
    // );
  }
}
