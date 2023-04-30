import 'package:get/get.dart';

import 'import_controller.dart';

class ImportBinding extends Bindings {
  final List<String> columnNames;
  final List<List<String>> transactions;

  ImportBinding({required this.columnNames, required this.transactions});

  @override
  void dependencies() {
    Get.lazyPut(
        () => ImportController(columnNames: columnNames, transactions: transactions));
  }
}
