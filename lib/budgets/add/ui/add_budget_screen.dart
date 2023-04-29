import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_colors.dart';
import '../../../common/ui/common_edit_text.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_toggle_buttons.dart';
import '../../common/data/models/budget_type.dart';
import '../domain/add_budget_controller.dart';
import 'budget_widgets.dart';

class AddBudgetScreen extends CommonScaffoldWithButtonScreen<AddBudgetController> {
  AddBudgetScreen({super.key})
      : super(
          Get.localisation.add_budget_title,
          icon: CommonIcons.check,
        );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              CommonEditText(
                controller: _nameController,
                hintText: Get.localisation.nameHint,
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(() {
                return CommonToggleButtons(
                  onItemClick: (index) async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    controller.changeSelectedBudgetType(BudgetType.values[index]);
                  },
                  isSelected: BudgetType.values
                      .map((e) => e == controller.budgetType.value)
                      .toList(),
                  fillColor: CommonColors.defColor,
                  children: BudgetType.values.map((e) {
                    return Text(e.name);
                  }).toList(),
                );
              }),
              const SizedBox(
                height: 8,
              ),
              Obx(() {
                final budgetType = controller.budgetType.value;
                switch (budgetType) {
                  case BudgetType.category:
                  case BudgetType.total:
                    return CommonBudgetWidget(
                      amountController: _amountController,
                      wallets: controller.wallets.value,
                      selectWallet: controller.selectWallet,
                      categories: controller.categories.value,
                      selectCategory: controller.selectCategory,
                      showCategory: budgetType == BudgetType.category,
                    );

                  case BudgetType.multiCategory:
                    return MultiCategoryBudgetWidget(
                      multiCategories: controller.multiCategories.value,
                      addMultiCategory: controller.addMultiCategory,
                      removeMultiCategory: controller.removeMultiCategory,
                      changeAmountInMultiCategory: controller.changeAmountInMultiCategory,
                      changeCategoryInMultiCategory:
                          controller.changeCategoryInMultiCategory,
                      changeWalletInMultiCategory: controller.changeWalletInMultiCategory,
                      wallets: controller.wallets.value,
                      categories: controller.categories.value,
                    );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onButtonPress(BuildContext context) {
    controller.saveBudget(_nameController.text, _amountController.text);
  }
}
