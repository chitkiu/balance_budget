import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/transaction_item/transaction_section_header_widget.dart';
import '../domain/wallet_info_controller.dart';

class WalletInfoScreen
    extends CommonScaffoldWithButtonScreen<WalletInfoController> {
  WalletInfoScreen({super.key})
      : super(Get.localisation.wallet_info_title, icon: CommonIcons.edit);

  @override
  Widget body(BuildContext context) {
    return controller.obx(
      (state) {
        if (state == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CommonUI.defaultTileHorizontalPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: CommonUI.defaultTileVerticalPadding,
                ),
                CommonTile(
                  text: "Wallet name:",
                  secondText: state.wallet.name,
                  icon: CommonIcons.wallet,
                ),
                const SizedBox(
                  height: CommonUI.defaultFullTileVerticalPadding,
                ),
                CommonTile(
                  text: "Total balance:",
                  secondText: state.wallet.balance,
                  icon: Icons.money,
                ),
                const SizedBox(
                  height: 16,
                ),
                ...state.transactions.transactions
                    .map((e) => TransactionSectionHeaderWidget(
                          model: e,
                          onItemClick: (transaction) {},
                          itemPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: CommonUI.defaultTileVerticalPadding),
                          titlePadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                        )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onButtonPress() {
    // TODO: implement onButtonPress
  }
}
