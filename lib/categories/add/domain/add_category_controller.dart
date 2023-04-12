import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../common/data/local_category_repository.dart';

class AddCategoryController extends GetxController {

  LocalCategoryRepository get _categoryRepo => Get.find();

  final selectedType = TransactionType.expense.obs;

  final selectedIcon = Icons.not_interested.obs;

  void onSaveCategory(String title) {
    if (title.isEmpty) {
      return;
    }

    _categoryRepo.create(title, selectedType.value, selectedIcon.value);

    Get.back();
  }

}