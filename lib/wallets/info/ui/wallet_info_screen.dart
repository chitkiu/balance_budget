import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/transaction_item/transaction_section_header_widget.dart';
import '../../list/ui/models/wallet_ui_model.dart';
import '../domain/wallet_info_controller.dart';

class WalletInfoScreen extends CommonScaffoldWithButtonScreen<WalletInfoController> {
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
        final wallet = state.wallet;
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CommonUI.defaultTileHorizontalPadding),
          child: Column(
            children: [
              const SizedBox(
                height: CommonUI.defaultTileVerticalPadding,
              ),
              CommonTile(
                text: Get.localisation.walletNameTitle,
                secondText: state.wallet.name,
                icon: CommonIcons.wallet,
              ),
              const SizedBox(
                height: CommonUI.defaultFullTileVerticalPadding,
              ),
              CommonTile(
                text: Get.localisation.totalBalanceTitle,
                secondText: state.wallet.balance,
                icon: Icons.money,
              ),
              const SizedBox(
                height: 16,
              ),
              if (wallet is CreditWalletUIModel)
                CommonTile(
                  text: Get.localisation.ownBalanceTitle,
                  secondText: wallet.ownSum,
                  icon: Icons.attach_money,
                ),
              if (wallet is CreditWalletUIModel)
                const SizedBox(
                  height: 16,
                ),
              if (wallet is CreditWalletUIModel)
                CommonTile(
                  text: Get.localisation.usedCreditLimitTitle,
                  secondText: "${wallet.spendedCreditSum}/${wallet.totalCreditSum}",
                  icon: Icons.credit_card,
                ),
              if (wallet is CreditWalletUIModel)
                const SizedBox(
                  height: 16,
                ),
              PlatformElevatedButton(
                onPressed: () async {
                  await confirmBeforeActionDialog(
                    () async {
                      await controller.archiveWallet();
                    },
                  );
                },
                child: Text(wallet.isArchived ? "Unarchive" : "Archive"),
              ),
              if (wallet.isArchived)
                PlatformElevatedButton(
                  onPressed: () async {
                    await confirmBeforeActionDialog(
                      () async {
                        try {
                          await controller.deleteWallet();
                          Get.back();
                        } on Exception catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                    );
                  },
                  child: Text("Delete"),
                ),
              const SizedBox(
                height: 16,
              ),
              if (state.transactions.transactions.isNotEmpty)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    Get.localisation.transaction_list_subtitle,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              if (state.transactions.transactions.isNotEmpty)
                const SizedBox(
                  height: 8,
                ),
              if (state.transactions.transactions.isNotEmpty)
                Expanded(
                    child: ListView.builder(
                  itemCount: state.transactions.transactions.length,
                  itemBuilder: (context, index) {
                    final model = state.transactions.transactions[index];
                    return TransactionSectionHeaderWidget(
                      model: model,
                      onItemClick: (transaction) {
                        controller.onTransactionClicked(context, transaction, !wallet.isArchived);
                      },
                      itemPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: CommonUI.defaultTileVerticalPadding),
                      titlePadding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    );
                  },
                )),
              if (state.transactions.transactions.isEmpty)
                Expanded(
                    child: Center(
                  child: Text(Get.localisation.noTransactions),
                ))
            ],
          ),
        );
      },
    );
  }

  @override
  void onButtonPress(BuildContext context) {
    // TODO: implement onButtonPress
  }
}
