import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../domain/accounts_controller.dart';
import 'models/account_ui_model.dart';

class AccountsScreen extends CommonScaffoldWithButtonScreen<AccountsController> {
  AccountsScreen({Key? key}) : super(
      Get.localisation.accountsTitle,
      icon: CommonIcons.add,
      key: key
  );

  @override
  Widget body(BuildContext context) {
    return StreamBuilder(
      stream: controller.getAccounts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        var accounts = snapshot.data;
        if (accounts == null || accounts.isEmpty) {
          return Center(
            child: Text(Get.localisation.noAccounts),
          );
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            return _getAccountWidget(accounts[index]);
          },
          itemCount: accounts.length,
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }

  @override
  void onButtonPress() {
    controller.onAddClick();
  }

  Widget _getAccountWidget(AccountUIModel account) {
    if (account is CreditAccountUIModel) {
      return _creditAccountWidget(account);
    } else {
      return _defaultAccountWidget(account);
    }
  }

  Widget _defaultAccountWidget(AccountUIModel account) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(account.name,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Get.localisation.totalBalance),
                Text(account.balance),
              ],
            )
          ],
        )
    );
  }

  Widget _creditAccountWidget(CreditAccountUIModel account) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(account.name,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Get.localisation.totalBalance),
                Text(account.balance),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Get.localisation.ownBalance),
                Text(account.ownSum),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Get.localisation.creditLimit),
                Text(account.creditSum),
              ],
            )
          ],
        )
    );
  }

}