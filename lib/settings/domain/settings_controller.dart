import 'package:get/get.dart';

import '../../accounts/list/domain/accounts_binding.dart';
import '../../accounts/list/ui/accounts_screen.dart';
import '../../categories/list/domain/categories_binding.dart';
import '../../categories/list/ui/categories_screen.dart';

class SettingsController extends GetxController {

  void onManageAccountsClick() {
    Get.to(
          () => AccountsScreen(),
      binding: AccountsBinding(),
    );
  }

  void onManageCategoriesClick() {
    Get.to(
          () => CategoriesScreen(),
      binding: CategoriesBinding(),
    );
  }

}