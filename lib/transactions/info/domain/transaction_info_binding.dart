import 'package:get/get.dart';

import 'transaction_info_controller.dart';

class TransactionInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransactionInfoController());
  }
}