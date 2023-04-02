import 'package:get/get.dart';

import 'transaction_info_controller.dart';

class TransactionInfoBinding extends Bindings {
  final String id;

  TransactionInfoBinding(this.id);

  @override
  void dependencies() {
    Get.put(TransactionInfoController(id));
  }
}