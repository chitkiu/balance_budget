import 'package:get/get.dart';

import '../../../common/domain/models/deletable_bindings.dart';
import '../../../common/getx_extensions.dart';
import 'accounts_controller.dart';

class AccountsBinding extends DeletableBindings {
  @override
  void dependencies() {
    Get.put(AccountsController());
  }

  @override
  void delete() {
    Get.deleteIfExist<AccountsController>();
  }

}