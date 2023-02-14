import 'package:get/get.dart';

import '../../../common/domain/models/deletable_bindings.dart';
import '../../../common/getx_extensions.dart';
import '../data/transactions_aggregator.dart';
import 'transactions_controller.dart';

class TransactionsBinding extends DeletableBindings {
  @override
  void delete() {
    Get.deleteIfExist<TransactionsController>();
    Get.deleteIfExist<TransactionsAggregator>();
  }

  @override
  void dependencies() {
    Get.lazyPut(() => const TransactionsAggregator());
    Get.put(TransactionsController());
  }

}