import 'dart:async';

import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../common/data/local_budget_repository.dart';
import '../ui/models/budget_ui_model.dart';
import 'mappers/budget_ui_mapper.dart';

class BudgetsController extends GetxController {

  LocalBudgetRepository get _budgetRepo => Get.find();
  LocalTransactionsRepository get _transactionRepo => Get.find();

  final BudgetUIMapper _mapper = const BudgetUIMapper();

  RxList<BudgetUIModel> budgets = <BudgetUIModel>[].obs;
  StreamSubscription? _listener;

  @override
  void onReady() {
    _listener?.cancel();
    _listener = CombineLatestStream.combine2(
        _budgetRepo.budgets.stream,
        _transactionRepo.transactions.stream,
        (budgets, transactions) {
      return budgets
          .map((e) => _mapper.map(e, transactions))
          .whereType<BudgetUIModel>()
          .toList();
    }).listen((value) {
      budgets.value = value;
    });

    _budgetRepo.budgets.refresh();
    _transactionRepo.transactions.refresh();

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
