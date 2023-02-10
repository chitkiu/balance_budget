import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:get/get.dart';

import '../../common/data/local_category_repository.dart';

class AddCategoryController extends GetxController {

  LocalCategoryRepository get _categoryRepo => Get.find();

  var selectedType = TransactionType.spend.obs;

  //TODO
  void onSaveCategory(String title) {
    if (title.isEmpty) {
      return;
    }

    _categoryRepo.create(title, selectedType.value, null);

    Get.back();
  }

}