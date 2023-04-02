import 'package:get/get.dart';

import '../../list/data/models/rich_transaction_model.dart';
import 'update_transaction_controller.dart';

class UpdateTransactionBinding extends Bindings {
  final RichTransactionModel? model;

  UpdateTransactionBinding({this.model});

  @override
  void dependencies() {
    Get.put(UpdateTransactionController(model: model));
  }

}