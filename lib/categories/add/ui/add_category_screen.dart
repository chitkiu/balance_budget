import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../translator_extension.dart';
import '../domain/add_category_controller.dart';

class AddCategoryScreen extends CommonScaffoldWithButtonScreen<AddCategoryController> {
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

        const SizedBox(height: 8,),
        Text(Get.localisation.transactionTypeHint),
        //TODO Make it cross-platform
        Obx(() {
          return DropdownButton(
            items: TransactionType.values.map((e) {
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
          );
        }),
      ],
    );
  }

  @override
  void onButtonPress() {
    controller.onSaveCategory(_nameController.text);
  }

}