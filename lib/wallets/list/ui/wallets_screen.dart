import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../domain/wallets_controller.dart';
import 'models/wallet_ui_model.dart';

class WalletsScreen extends CommonScaffoldWithButtonScreen<WalletsController> {
  WalletsScreen({Key? key})
      : super(Get.localisation.walletsTitle, icon: CommonIcons.add, key: key);

  @override
  Widget body(BuildContext context) {
    return StreamBuilder(
      stream: controller.getWallets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        var wallets = snapshot.data;
        if (wallets == null || wallets.isEmpty) {
          return Center(
            child: Text(Get.localisation.noWallets),
          );
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            var wallet = wallets[index];
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.onItemClick(wallet);
              },
              child: _getWalletWidget(wallet),
            );
          },
          itemCount: wallets.length,
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }

  @override
  void onButtonPress() {
    controller.onAddClick();
  }

  Widget _getWalletWidget(WalletUIModel wallet) {
    if (wallet is CreditWalletUIModel) {
      return _creditWalletWidget(wallet);
    } else {
      return _defaultWalletWidget(wallet);
    }
  }

  Widget _defaultWalletWidget(WalletUIModel wallet) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(wallet.name,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Get.localisation.totalBalance),
                Text(wallet.balance),
              ],
            )
          ],
        ));
  }

  Widget _creditWalletWidget(CreditWalletUIModel wallet) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(wallet.name,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Get.localisation.totalBalance),
                Text(wallet.balance),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Get.localisation.ownBalance),
                Text(wallet.ownSum),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Get.localisation.creditLimit),
                Text(wallet.creditSum),
              ],
            )
          ],
        ));
  }
}
