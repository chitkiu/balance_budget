import 'package:get/get.dart';

import '../../../common/domain/models/deletable_bindings.dart';
import '../../../common/getx_extensions.dart';
import 'wallets_controller.dart';

class WalletsBinding extends DeletableBindings {
  @override
  void dependencies() {
    Get.put(WalletsController());
  }

  @override
  void delete() {
    Get.deleteIfExist<WalletsController>();
  }

}