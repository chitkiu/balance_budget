import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/platform_dropdown_button.dart';
import '../domain/add_wallet_controller.dart';
import 'models/wallet_type.dart';

class AddWalletScreen extends CommonScaffoldWithButtonScreen<AddWalletController> {
  AddWalletScreen({super.key}) : super(
    Get.localisation.addWalletTitle,
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
        Text(Get.localisation.addWalletTypeSelector),
        Obx(() {
          return PlatformDropdownButton(
            items: WalletType.values.map((e) {
              return DropdownMenuItem<WalletType>(
                value: e,
                child: Text(e.name),
              );
            }).toList(),
            value: controller.walletType.value,
            onChanged: (value) {
              if (value != null) {
                controller.walletType.value = value;
              }
            },
            cupertino: cupertinoDropdownButtonData,
          );
        }),
        Obx(() {
          WalletType walletType = controller.walletType.value;
          switch (walletType) {
            case WalletType.debit:
              _totalBalanceController.clear();
              return PlatformTextField(
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                controller: _totalBalanceController,
                material: (context, platform) {
                  return MaterialTextFieldData(
                      decoration: InputDecoration(
                          labelText: Get.localisation.addWalletTotalBalanceHint
                      )
                  );
                },
                cupertino: (context, platform) {
                  return CupertinoTextFieldData(
                      placeholder: Get.localisation.addWalletTotalBalanceHint
                  );
                },
              );
            case WalletType.credit:
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
                              labelText: Get.localisation.addWalletOwnBalanceHint
                          )
                      );
                    },
                    cupertino: (context, platform) {
                      return CupertinoTextFieldData(
                          placeholder: Get.localisation.addWalletOwnBalanceHint
                      );
                    },
                  ),
                  PlatformTextField(
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    controller: _creditBalanceController,
                    material: (context, platform) {
                      return MaterialTextFieldData(
                          decoration: InputDecoration(
                              labelText: Get.localisation.addWalletCreditLimit
                          )
                      );
                    },
                    cupertino: (context, platform) {
                      return CupertinoTextFieldData(
                          placeholder: Get.localisation.addWalletCreditLimit
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
    await controller.onSaveWallet(
      title: _nameController.text,
      totalBalance: _totalBalanceController.text,
      ownBalance: _ownBalanceController.text,
      creditBalance: _creditBalanceController.text,
    );
  }

}