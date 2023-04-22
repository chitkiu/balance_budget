import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../domain/wallets_controller.dart';
import 'models/wallet_ui_model.dart';

class WalletsScreen extends CommonScaffoldWithButtonScreen<WalletsController> {
  WalletsScreen({Key? key})
      : super(Get.localisation.walletsTitle, icon: CommonIcons.add, key: key);

  @override
  Widget body(BuildContext context) {
    return controller.obx((wallets) {
      if (wallets == null || wallets.isEmpty) {
        return Center(
          child: Text(Get.localisation.noWallets),
        );
      }
      return ListView.separated(
        itemBuilder: (context, index) => _walletWidget(context, wallets[index]),
        itemCount: wallets.length,
        separatorBuilder: (context, index) => const Divider(),
      );
    },
        onEmpty: Center(
          child: Text(Get.localisation.noWallets),
        ));
  }

  @override
  void onButtonPress(BuildContext context) {
    controller.onAddClick();
  }

  Widget _walletWidget(BuildContext context, WalletUIModel wallet) {
    final textTheme = Theme.of(context).textTheme;

    Widget? additionalText;

    if (wallet is CreditWalletUIModel) {
      additionalText = Text(
          Get.localisation
              .usedCreditLimit(wallet.totalCreditSum, wallet.spendedCreditSum),
          style: textTheme.titleSmall);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.onItemClick(wallet);
      },
      child: Padding(
        padding: CommonUI.defaultTilePadding,
        child: CommonTile(
          icon: CommonIcons.wallet,
          textWidget: Text(
            wallet.name,
            style: textTheme.titleMedium,
          ),
          secondTextWidget: Text(Get.localisation.totalBalance(wallet.balance),
              style: textTheme.titleSmall),
          additionalTextWidget: additionalText,
        ),
      ),
    );
  }
}
