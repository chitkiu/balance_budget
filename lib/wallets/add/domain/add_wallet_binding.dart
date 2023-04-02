import 'package:get/get.dart';

import 'add_wallet_controller.dart';

class AddWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddWalletController());
  }

}