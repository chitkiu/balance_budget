import 'package:balance_budget/budgets/add/domain/add_budget_controller.dart';
import 'package:get/get.dart';

class AddBudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddBudgetController());
  }

}