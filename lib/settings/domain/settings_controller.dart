import 'package:get/get.dart';

import '../../categories/list/domain/categories_binding.dart';
import '../../categories/list/ui/categories_screen.dart';

class SettingsController extends GetxController {

  void onManageCategoriesClick() {
    Get.to(
          () => CategoriesScreen(),
      binding: CategoriesBinding(),
    );
  }

}