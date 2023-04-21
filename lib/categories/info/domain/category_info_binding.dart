import 'package:get/get.dart';

import '../../../transactions/list/data/transactions_aggregator.dart';
import '../data/category_transactions_aggregator.dart';
import 'category_info_controller.dart';

class CategoryInfoBinding extends Bindings {
  final String id;

  CategoryInfoBinding(this.id);

  @override
  void dependencies() {
    Get.lazyPut(() => const CategoryTransactionsAggregator());
    ///Added for transaction info screen
    Get.lazyPut(() => const TransactionsAggregator());
    Get.put(CategoryInfoController(id));
  }
}
