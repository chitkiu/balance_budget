import 'package:get/get.dart';

import 'add_spend_controller.dart';

class AddSpendBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddSpendController());
  }

}