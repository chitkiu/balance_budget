import 'package:balance_budget/categories/info/domain/category_info_binding.dart';
import 'package:balance_budget/common/ui/common_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../info/ui/category_info_screen.dart';
import '../domain/categories_controller.dart';

class CategoriesScreen extends CommonScaffoldWithButtonScreen<CategoriesController> {
  CategoriesScreen({Key? key})
      : super(Get.localisation.categoriesTitle, icon: CommonIcons.add, key: key);

  @override
  Widget body(BuildContext context) {
    return controller.obx((categories) {
      if (categories == null || categories.isEmpty) {
        return Center(
          child: Text(Get.localisation.noCategories),
        );
      }
      return ListView.separated(
        itemBuilder: (context, index) {
          var category = categories[index];
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.to(() => CategoryInfoScreen(),
                  binding: CategoryInfoBinding(category.id));
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CommonUI.defaultTileHorizontalPadding),
                child: CommonTile(icon: category.icon, text: category.name)),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: categories.length,
      );
    },
        onEmpty: Center(
          child: Text(Get.localisation.noCategories),
        ));
  }

  @override
  void onButtonPress(BuildContext context) {
    controller.onAddClick();
  }
}
