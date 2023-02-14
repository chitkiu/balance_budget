import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../domain/add_category_controller.dart';

class AddCategoryScreen extends CommonScaffoldWithButtonScreen<AddCategoryController> {
  AddCategoryScreen({super.key}) : super(
    Get.localisation.addCategory,
    icon: CommonIcons.check,
  );

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

        const SizedBox(height: 8,),
        Text(Get.localisation.transactionTypeHint),
        Obx(() {
          return PlatformDropdownButton(
            items: TransactionType.visibleTypes.map((e) {
              return DropdownMenuItem<TransactionType>(
                value: e,
                child: Text(e.name),
              );
            }).toList(),
            value: controller.selectedType.value,
            onChanged: (value) {
              if (value != null) {
                controller.selectedType.value = value;
              }
            },
            cupertino: cupertinoDropdownButtonData,
          );
        })
      ],
    );
  }

  @override
  void onButtonPress() {
    controller.onSaveCategory(_nameController.text);
  }

}