import 'package:get/get.dart';

import '../../common/data/local_category_repository.dart';

class AddCategoryController extends GetxController {

  LocalCategoryRepository get _categoryRepo => Get.find();

  //TODO
  void onSaveCategory(String title) {
    if (title.isEmpty) {
      return;
    }

    _categoryRepo.create(title, null);

    Get.back();
  }

}