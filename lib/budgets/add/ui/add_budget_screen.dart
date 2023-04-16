import 'package:balance_budget/budgets/common/data/models/budget_type.dart';
import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_colors.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_toggle_buttons.dart';
import '../domain/add_budget_controller.dart';

class AddBudgetScreen extends CommonScaffoldWithButtonScreen<AddBudgetController> {
  AddBudgetScreen({super.key})
      : super(
          Get.localisation.add_budget_title,
          icon: CommonIcons.check,
        );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final _isAllWalletSelected = true.obs;

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            PlatformTextField(
              controller: _nameController,
              material: (context, platform) {
                return MaterialTextFieldData(
                    decoration: InputDecoration(labelText: Get.localisation.nameHint));
              },
              cupertino: (context, platform) {
                return CupertinoTextFieldData(placeholder: Get.localisation.nameHint);
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Obx(() {
              return CommonToggleButtons(
                onItemClick: (index) async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  controller.budgetType.value = BudgetType.values[index];
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
              if (controller.budgetType.value != BudgetType.multiCategory) {
                return Column(
                  children: [
                    Text("Select wallet, or keep empty for all wallets"),
                    CommonToggleButtons(
                      onItemClick: (index) async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _isAllWalletSelected.value = index == 0;
                      },
                      isSelected: [
                        _isAllWalletSelected.value,
                        !_isAllWalletSelected.value,
                      ],
                      fillColor: CommonColors.defColor,
                      children: const [
                        Text("All wallets"),
                        Text("Only selected wallets"),
                      ],
                    ),
                    if (!_isAllWalletSelected.value)
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: controller.wallets.map((element) {
                            return PlatformTextButton(
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                controller.selectWallet(element.model);
                              },
                              child: Row(
                                children: [
                                  Text(element.model.name),
                                  if (element.isSelected) Icon(CommonIcons.ok)
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                );
              } else {
                return Container();
              }
            }),
            Obx(() {
              if (controller.budgetType.value == BudgetType.category) {
                return Column(
                  children: [
                    Text("Select category"),
                    SizedBox(
                      height: 50,
                      child: Obx(() {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: controller.categories.map((element) {
                            return PlatformTextButton(
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                controller.selectCategory(element.model);
                              },
                              child: Row(
                                children: [
                                  Text(element.model.name),
                                  if (element.isSelected) Icon(CommonIcons.ok)
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
            Obx(() {
              if (controller.budgetType.value != BudgetType.multiCategory) {
                return Column(
                  children: [
                    PlatformTextField(
                      controller: _amountController,
                      material: (context, platform) {
                        return MaterialTextFieldData(
                            decoration: InputDecoration(labelText: "Sum"));
                      },
                      cupertino: (context, platform) {
                        return CupertinoTextFieldData(placeholder: "Sum");
                      },
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
            Obx(() {
              if (controller.budgetType.value == BudgetType.multiCategory) {
                if (controller.multiCategories.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Text("You don't add any categories, please press plus for add"),
                        PlatformElevatedButton(
                          child: const Icon(Icons.add), //TODO
                          onPressed: () {
                            controller.addMultiCategory();
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  var children = <Widget>[];
                  final items = controller.multiCategories.value;
                  for (var i = 0; i < items.length; i++) {
                    final item = items[i];
                    children.addAll([
                      PlatformTextButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller.removeMultiCategory(i);
                        },
                        child: Text("Remove category"),
                      ),
                      Text("Select category:"),
                      SizedBox(
                        height: 50,
                        child: Obx(() {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: controller.categories.map((element) {
                              final isSelected = item.category?.id == element.model.id;
                              return PlatformTextButton(
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  controller.changeCategoryInMultiCategory(
                                      i, element.model);
                                },
                                child: Row(
                                  children: [
                                    Text(element.model.name),
                                    if (isSelected) Icon(CommonIcons.ok)
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ),
                      Text("Select wallet, or keep empty for all wallets"),
                      CommonToggleButtons(
                        onItemClick: (index) async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller.changeWalletSelectionInMultiCategory(i, index == 0);
                        },
                        isSelected: [
                          item.isAllWalletSelected,
                          !item.isAllWalletSelected,
                        ],
                        fillColor: CommonColors.defColor,
                        children: const [
                          Text("All wallets"),
                          Text("Only selected wallets"),
                        ],
                      ),
                      if (!item.isAllWalletSelected)
                        SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: controller.wallets.map((element) {
                              final isSelected = item.wallets
                                  .any((wallet) => wallet.id == element.model.id);
                              return PlatformTextButton(
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  controller.changeWalletInMultiCategory(
                                      i, element.model);
                                },
                                child: Row(
                                  children: [
                                    Text(element.model.name),
                                    if (isSelected) Icon(CommonIcons.ok)
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      PlatformTextField(
                        onChanged: (p0) {
                          controller.changeAmountInMultiCategory(i, p0);
                        },
                        material: (context, platform) {
                          return MaterialTextFieldData(
                              decoration: InputDecoration(labelText: "Sum"));
                        },
                        cupertino: (context, platform) {
                          return CupertinoTextFieldData(placeholder: "Sum");
                        },
                      ),
                      const Divider(),
                    ]);
                  }

                  children.add(Row(
                    children: [
                      Text("Add new actegory"),
                      PlatformElevatedButton(
                        child: const Icon(Icons.add), //TODO
                        onPressed: () {
                          controller.addMultiCategory();
                        },
                      ),
                    ],
                  ));
                  return Column(children: children);
                }
              } else {
                return Container();
              }
            }),
          ],
        ),
      ),
    );
  }

  @override
  void onButtonPress(BuildContext context) {
    controller.saveBudget(_nameController.text, _amountController.text, _isAllWalletSelected.value);
  }
}
