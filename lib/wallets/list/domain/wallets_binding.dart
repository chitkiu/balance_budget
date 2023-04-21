import 'package:get/get.dart';

import '../../../common/domain/models/deletable_bindings.dart';
import '../../../common/getx_extensions.dart';
import '../data/filtered_transactions_repository.dart';
import 'wallets_controller.dart';

class WalletsBinding extends DeletableBindings {
  @override
  void dependencies() {
    Get.lazyPut(() => const FilteredTransactionsRepository());
    Get.put(WalletsController());
  }

  @override
  void delete() {
    Get.deleteIfExist<WalletsController>();
  }

}