import 'package:balance_budget/common/ui/common_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_colors.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_toggle_buttons.dart';
import '../domain/add_category_controller.dart';

class AddCategoryScreen extends CommonScaffoldWithButtonScreen<AddCategoryController> {
  AddCategoryScreen({super.key})
      : super(
          Get.localisation.addCategoryTitle,
          icon: CommonIcons.check,
        );

  final TextEditingController _nameController = TextEditingController();

  final _nameInputKey = GlobalKey<FormFieldState>();

  @override
  Widget body(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          CommonEditText(
            widgetKey: _nameInputKey,
            controller: _nameController,
            validator: controller.validateName,
            hintText: Get.localisation.nameHint,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),

          const SizedBox(
            height: 8,
          ),
          Text(Get.localisation.transactionTypeHint),
          Obx(() {
            return CommonToggleButtons(
                onItemClick: (index) async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  var type = TransactionType.canAddCategory[index];
                  controller.selectedType.value = type;
                },
                isSelected: TransactionType.canAddCategory
                    .map((e) => e == controller.selectedType.value)
                    .toList(),
                fillColor: _getBackgroundColorBySelectedType(controller.selectedType.value),
                children: TransactionType.canAddCategory.map((e) {
                  return Text(e.name);
                }).toList()
            );
          }),
          const SizedBox(
            height: 8,
          ),
          //TODO Improve UI
          Row(
            children: [
              Text("Selected icon:"),
              Obx(() => Icon(controller.selectedIcon.value ?? Icons.not_interested)),
              PlatformElevatedButton(
                child: Text("Select icon"),
                onPressed: () async {
                  controller.onIconPickerClick();
                  FocusScope.of(context).requestFocus(FocusNode());

                  IconData? icon = await FlutterIconPicker.showIconPicker(context,
                      iconPackModes: [IconPack.custom],
                      customIconPack: CommonIcons.icons);

                  if (icon != null) {
                    controller.selectedIcon.value = icon;
                  }
                },
              )
            ],
          ),
          Obx(() {
            final errorText = controller.iconError.value;
            if (errorText != null) {
              return Text(
                errorText,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.start,
              );
            } else {
              return Container();
            }
          })
        ],
      ),
    );
  }

  Color _getBackgroundColorBySelectedType(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return CommonColors.expense;
      case TransactionType.income:
        return CommonColors.income;
      case TransactionType.transfer:
      case TransactionType.setInitialBalance:
        return CommonColors.defColor;
    }
  }

  @override
  void onButtonPress(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_nameInputKey.currentState?.validate() == true) {
      controller.onSaveCategory(_nameController.text);
    }
  }
}
