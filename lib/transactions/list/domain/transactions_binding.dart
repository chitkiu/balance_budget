import 'package:get/get.dart';

import '../../../common/domain/models/deletable_bindings.dart';
import '../../../common/getx_extensions.dart';
import 'transactions_controller.dart';

class TransactionsBinding extends DeletableBindings {
  @override
  void delete() {
    Get.deleteIfExist<TransactionsController>();
  }

  @override
  void dependencies() {
    Get.put(TransactionsController());
  }
}
