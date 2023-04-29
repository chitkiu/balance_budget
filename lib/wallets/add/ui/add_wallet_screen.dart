import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_colors.dart';
import '../../../common/ui/common_edit_text.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_toggle_buttons.dart';
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

  final _nameInputKey = GlobalKey<FormFieldState>();
  final _totalBalanceInputKey = GlobalKey<FormFieldState>();
  final _ownBalanceInputKey = GlobalKey<FormFieldState>();
  final _creditBalanceInputKey = GlobalKey<FormFieldState>();

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
            hintText: Get.localisation.nameHint,
            validator: controller.validateName,
          ),
          const SizedBox(height: 8,),
          Text(Get.localisation.addWalletTypeSelector),
          Obx(() {
            return CommonToggleButtons(
              onItemClick: (index) async {
                FocusScope.of(context).requestFocus(FocusNode());
                var type = WalletType.values[index];
                controller.walletType.value = type;
              },
              isSelected: WalletType.values
                  .map((e) => e == controller.walletType.value)
                  .toList(),
              fillColor: CommonColors.defColor,
              children: WalletType.values.map((e) {
                return Text(e.name);
              }).toList(),
            );
          }),
          Obx(() {
            WalletType walletType = controller.walletType.value;
            switch (walletType) {
              case WalletType.debit:
                _totalBalanceController.clear();
                return CommonEditText(
                  widgetKey: _totalBalanceInputKey,
                  validator: controller.validateNumber,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  controller: _totalBalanceController,
                  hintText: Get.localisation.addWalletTotalBalanceHint,
                );
              case WalletType.credit:
                _ownBalanceController.clear();
                _creditBalanceController.clear();
                return Column(
                  children: [
                    CommonEditText(
                      widgetKey: _ownBalanceInputKey,
                      validator: controller.validateNumber,
                      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                      controller: _ownBalanceController,
                      hintText: Get.localisation.addWalletOwnBalanceHint,
                    ),
                    CommonEditText(
                      widgetKey: _creditBalanceInputKey,
                      validator: controller.validateNumber,
                      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                      controller: _creditBalanceController,
                      hintText: Get.localisation.addWalletCreditLimit,
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

    if (_nameInputKey.currentState?.validate() == true) {
      if (
      _totalBalanceInputKey.currentState?.validate() == true ||
          (_ownBalanceInputKey.currentState?.validate() == true &&
              _creditBalanceInputKey.currentState?.validate() == true)
      ) {
        await controller.onSaveWallet(
          title: _nameController.text,
          totalBalance: _totalBalanceController.text,
          ownBalance: _ownBalanceController.text,
          creditBalance: _creditBalanceController.text,
        );
      }
    }
  }

}