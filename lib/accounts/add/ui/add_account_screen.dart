import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../domain/add_account_controller.dart';
import 'models/account_type.dart';

class AddAccountScreen extends CommonScaffoldWithButtonScreen<AddAccountController> {
  AddAccountScreen({super.key}) : super(
    Get.localisation.addAccountTitle,
    icon: CommonIcons.check,
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _totalBalanceController = TextEditingController();
  final TextEditingController _ownBalanceController = TextEditingController();
  final TextEditingController _creditBalanceController = TextEditingController();

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
        Text(Get.localisation.addAccountTypeSelector),
        Obx(() {
          return PlatformDropdownButton(
            items: AccountType.values.map((e) {
              return DropdownMenuItem<AccountType>(
                value: e,
                child: Text(e.name),
              );
            }).toList(),
            value: controller.accountType.value,
            onChanged: (value) {
              if (value != null) {
                controller.accountType.value = value;
              }
            },
            cupertino: cupertinoDropdownButtonData,
          );
        }),
        Obx(() {
          AccountType accountType = controller.accountType.value;
          switch (accountType) {
            case AccountType.debit:
              _totalBalanceController.clear();
              return PlatformTextField(
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                controller: _totalBalanceController,
                material: (context, platform) {
                  return MaterialTextFieldData(
                      decoration: InputDecoration(
                          labelText: Get.localisation.addAccountTotalBalanceHint
                      )
                  );
                },
                cupertino: (context, platform) {
                  return CupertinoTextFieldData(
                      placeholder: Get.localisation.addAccountTotalBalanceHint
                  );
                },
              );
            case AccountType.credit:
              _ownBalanceController.clear();
              _creditBalanceController.clear();
              return Column(
                children: [
                  PlatformTextField(
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    controller: _ownBalanceController,
                    material: (context, platform) {
                      return MaterialTextFieldData(
                          decoration: InputDecoration(
                              labelText: Get.localisation.addAccountOwnBalanceHint
                          )
                      );
                    },
                    cupertino: (context, platform) {
                      return CupertinoTextFieldData(
                          placeholder: Get.localisation.addAccountOwnBalanceHint
                      );
                    },
                  ),
                  PlatformTextField(
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    controller: _creditBalanceController,
                    material: (context, platform) {
                      return MaterialTextFieldData(
                          decoration: InputDecoration(
                              labelText: Get.localisation.addAccountCreditBalance
                          )
                      );
                    },
                    cupertino: (context, platform) {
                      return CupertinoTextFieldData(
                          placeholder: Get.localisation.addAccountCreditBalance
                      );
                    },
                  ),
                ],
              );
          }
        })
      ],
    );
  }

  @override
  void onButtonPress() async {
    await controller.onSaveAccount(
      title: _nameController.text,
      totalBalance: _totalBalanceController.text,
      ownBalance: _ownBalanceController.text,
      creditBalance: _creditBalanceController.text,
    );
  }

}