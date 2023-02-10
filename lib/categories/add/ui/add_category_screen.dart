import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_add_screen.dart';
import '../../../translator_extension.dart';
import '../domain/add_category_controller.dart';

class AddCategoryScreen extends CommonAddScreen<AddCategoryController> {
  AddCategoryScreen({super.key}) : super(Get.localisation.addCategory);

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        PlatformTextField(
          controller: _nameController,
          material: (context, platform) {
            return MaterialTextFieldData(
                decoration: InputDecoration(
                    labelText: Get.localisation.nameHint
                )
            );
          },
          cupertino: (context, platform) {
            return CupertinoTextFieldData(
                placeholder: Get.localisation.nameHint
            );
          },
        ),
      ],
    );
  }

  @override
  void onSubmit() {
    controller.onSaveCategory(_nameController.text);
  }

}