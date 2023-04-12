import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/platform_dropdown_button.dart';
import '../domain/add_category_controller.dart';

class AddCategoryScreen extends CommonScaffoldWithButtonScreen<AddCategoryController> {
  AddCategoryScreen({super.key}) : super(
    Get.localisation.addCategoryTitle,
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
            items: TransactionType.canAddCategory.map((e) {
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
        }),
        const SizedBox(height: 8,),
        //TODO Improve UI
        Row(
          children: [
            Text("Selected icon:"),
            Obx(() => Icon(controller.selectedIcon.value)),
            PlatformElevatedButton(
              child: Text("Select icon"),
              onPressed: () async {
                IconData? icon = await FlutterIconPicker.showIconPicker(
                    context, iconPackModes: [IconPack.custom],
                    customIconPack: CommonIcons.icons);

                if (icon != null) {
                  controller.selectedIcon.value = icon;
                }
              },
            )
          ],
        ),
      ],
    );
  }

  @override
  void onButtonPress() {
    controller.onSaveCategory(_nameController.text);
  }

}