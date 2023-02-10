import 'package:balance_budget/accounts/add/ui/models/account_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../translator_extension.dart';
import '../domain/add_account_controller.dart';

class AddAccountScreen extends GetView<AddAccountController> {
  AddAccountScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _totalBalanceController = TextEditingController();
  final TextEditingController _ownBalanceController = TextEditingController();
  final TextEditingController _creditBalanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(Get.localisation.addAccount),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
              trailing: CupertinoButton(
                child: const Icon(CupertinoIcons.checkmark),
                onPressed: () {
                  _saveAccount();
                },
              )
          );
        },
      ),
      body: Column(
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
          //TODO Make it cross-platform
          Obx(() {
            return DropdownButton(
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
      ),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _saveAccount();
              },
              child: const Icon(Icons.check),
            )
        );
      },
    );
  }

  void _saveAccount() {
    controller.onSaveAccount(
      title: _nameController.text,
      totalBalance: _totalBalanceController.text,
      ownBalance: _ownBalanceController.text,
      creditBalance: _creditBalanceController.text,
    );
  }

}