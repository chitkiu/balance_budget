import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../domain/categories_controller.dart';

class CategoriesScreen extends CommonScaffoldWithButtonScreen<CategoriesController> {
  CategoriesScreen({Key? key})
      : super(Get.localisation.categoriesTitle, icon: CommonIcons.add, key: key);

  @override
  Widget body(BuildContext context) {
    return StreamBuilder(
        stream: controller.getCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
          var categories = snapshot.data;
          if (categories == null || categories.isEmpty) {
            return Center(
              child: Text(Get.localisation.noCategories),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              var category = categories[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(category.name,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ));
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: categories.length,
          );
        });
  }

  @override
  void onButtonPress() {
    controller.onAddClick();
  }
}
