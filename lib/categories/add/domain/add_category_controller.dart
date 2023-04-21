import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/domain/name_validator.dart';
import '../../common/data/local_category_repository.dart';

class AddCategoryController extends GetxController with NameValidator {

  LocalCategoryRepository get _categoryRepo => Get.find();

  final selectedType = TransactionType.expense.obs;

  final selectedIcon = Rxn<IconData>();

  final iconError = Rxn<String>();

  void onSaveCategory(String title) {
    final titleError = validateName(title);

    if (titleError != null) {
      return;
    }

    final icon = selectedIcon.value;

    if (icon == null) {
      //TODO Add translation
      iconError.value = "No icon selected!";
      return;
    }

    _categoryRepo.create(title, selectedType.value, icon);

    Get.back();
  }

  void onIconPickerClick() {
    iconError.value = null;
  }

}