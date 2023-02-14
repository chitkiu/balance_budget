import 'package:get/get.dart';

import '../../../common/domain/models/deletable_bindings.dart';
import '../../../common/getx_extensions.dart';
import '../data/budget_aggregator.dart';
import 'budgets_controller.dart';

class BudgetsBinding extends DeletableBindings {
  @override
  void delete() {
    Get.deleteIfExist<BudgetsController>();
    Get.deleteIfExist<BudgetAggregator>();
  }

  @override
  void dependencies() {
    Get.lazyPut(() => const BudgetAggregator());

    Get.put(BudgetsController());
  }

}