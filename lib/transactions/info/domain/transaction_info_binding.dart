import 'package:get/get.dart';

import '../../../common/domain/models/deletable_bindings.dart';
import '../../../common/getx_extensions.dart';
import 'transaction_info_controller.dart';

class TransactionInfoBinding extends DeletableBindings {
  @override
  void dependencies() {
    Get.put(TransactionInfoController());
  }

  @override
  void delete() {
    Get.deleteIfExist<TransactionInfoController>();
  }

}