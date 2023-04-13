import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_colors.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
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
    return GestureDetector(
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
          LayoutBuilder(builder: (buildContext, constraints) {
            return Obx(() {
              return ToggleButtons(
                onPressed: (index) async {
                  FocusScope.of(buildContext).requestFocus(FocusNode());
                  var type = WalletType.values[index];
                  controller.walletType.value = type;
                },
                isSelected: WalletType.values
                    .map((e) => e == controller.walletType.value)
                    .toList(),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.grey,
                borderColor: Colors.grey,
                selectedColor: Colors.white,
                fillColor: CommonColors.defColor,
                color: Colors.black,
                constraints: BoxConstraints(
                  minHeight: 40.0,
                  minWidth: (constraints.maxWidth - 8 * 2) /
                      WalletType.values.length,
                ),
                children: WalletType.values.map((e) {
                  return Text(e.name);
                }).toList(),
              );
            });
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
      ),
    );
  }

  @override
  void onButtonPress(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await controller.onSaveWallet(
      title: _nameController.text,
      totalBalance: _totalBalanceController.text,
      ownBalance: _ownBalanceController.text,
      creditBalance: _creditBalanceController.text,
    );
  }

}