import 'package:get/get.dart';

import 'add_budget_controller.dart';

class AddBudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddBudgetController());
  }

}