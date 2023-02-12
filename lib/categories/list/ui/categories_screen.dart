import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../translator_extension.dart';
import '../domain/categories_controller.dart';

class CategoriesScreen extends CommonScaffoldWithButtonScreen<CategoriesController> {
  CategoriesScreen({Key? key}) : super(
      Get.localisation.categoriesTitle,
      icon: CommonIcons.add,
      key: key
  );

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      var categories = controller.categories;
      return ListView.builder(
        itemBuilder: (context, index) {
          var category = categories[index];
          return Row(
            children: [
              Text(category.name)
            ],
          );
        },
        itemCount: categories.length,
      );
    });
  }

  @override
  void onButtonPress() {
    controller.onAddClick();
  }

}