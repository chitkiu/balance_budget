import 'package:balance_budget/transactions/add/ui/date_time_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../domain/add_transaction_controller.dart';
import 'models/transaction_account_ui_model.dart';

class AddTransactionScreen
    extends CommonScaffoldWithButtonScreen<AddTransactionController> {
  AddTransactionScreen({super.key}) : super(
    Get.localisation.addTransactionTitle,
    icon: CommonIcons.check,
  );

  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(Get.localisation.transactionTypeHint),
          Obx(() {
            return ToggleButtons(
              onPressed: (index) async {
                var type = TransactionType.visibleTypes[index];
                controller.selectedType.value = type;
              },
              isSelected: TransactionType.visibleTypes
                  .map((e) => e == controller.selectedType.value)
                  .toList(),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.green[700],
              selectedColor: Colors.white,
              fillColor: Colors.green[200],
              color: Colors.green[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              children: TransactionType.visibleTypes.map((e) {
                return Text(e.name);
              })
                  .toList(),
            );
          }),

          const SizedBox(
            height: 8,
          ),
          PlatformTextField(
            keyboardType:
                const TextInputType.numberWithOptions(signed: true, decimal: true),
            controller: _sumController,
            material: (context, platform) {
              return MaterialTextFieldData(
                  decoration: InputDecoration(
                      labelText: Get.localisation.addTransactionSumHint
                  )
              );
            },
            cupertino: (context, platform) {
              return CupertinoTextFieldData(
                  placeholder: Get.localisation.addTransactionSumHint
              );
            },
          ),

          Obx(() {
            if (controller.selectedType.value != TransactionType.transfer) {
              return Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Get.localisation.addTransactionCategoryHint),
                      PlatformTextButton(
                        onPressed: controller.onManageCategoriesClick,
                        child: Text(Get.localisation.manageCategoriesButtonText),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: Obx(() {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: controller.categoryList.map((element) {
                          return PlatformTextButton(
                            onPressed: () {
                              controller.selectCategory(element);
                            },
                            child: Row(
                              children: [
                                Text(element.title),
                                if (element.isSelected)
                                  Icon(CommonIcons.ok)
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

          ..._selectAccount(controller.selectedAccount, (p0) => controller.selectAccount(p0)),

          Obx(() {
            if (controller.selectedType.value == TransactionType.transfer) {
              return Column(
                children: _selectAccount(controller.selectedToAccount, (p0) => controller.selectToAccount(p0)),
              );
            } else {
              return Container();
            }
          }),

          const SizedBox(
            height: 8,
          ),
          PlatformTextField(
            controller: _commentController,
            material: (context, platform) {
              return MaterialTextFieldData(
                  decoration: InputDecoration(
                      labelText: Get.localisation.addTransactionCommentHint));
            },
            cupertino: (context, platform) {
              return CupertinoTextFieldData(
                  placeholder: Get.localisation.addTransactionCommentHint);
            },
          ),

          const SizedBox(
            height: 8,
          ),
          DateTimeSelectorWidget(
            controller.selectedDate,
            controller.selectDateByType,
          )
        ],
      ),
    );
  }

  @override
  void onButtonPress() {
    controller.onSaveTransaction(_sumController.text, _commentController.text);
  }

  List<Widget> _selectAccount(
      Rxn<String> selectedAccount,
      void Function(TransactionAccountUIModel) onAccountSelected,
  ) {
    return [
      const SizedBox(
        height: 8,
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Get.localisation.addTransactionAccountHint),
          PlatformTextButton(
            onPressed: controller.onManageAccountsClick,
            child: Text(Get.localisation.manageAccountsButtonText),
          )
        ],
      ),
      SizedBox(
        height: 50,
        child: Obx(() {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: controller.accountList.map((element) {
              return PlatformTextButton(
                onPressed: () {
                  onAccountSelected(element);
                },
                child: Row(
                  children: [
                    Text(element.title),
                    if (selectedAccount.value == element.accountId)
                      Icon(CommonIcons.ok)
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ),
    ];
  }
}
