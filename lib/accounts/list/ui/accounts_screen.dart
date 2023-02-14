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
    return Obx(() {
      var accounts = controller.accounts;
      return ListView.separated(
        itemBuilder: (context, index) {
          return _getAccountWidget(accounts[index]);
        },
        itemCount: accounts.length,
        separatorBuilder: (context, index) => const Divider(),
      );
    });
  }

  @override
  void onButtonPress() {
    controller.onAddClick();
  }

  Widget _getAccountWidget(AccountUIModel account) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(account.name,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(account.balance,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        )
    );
  }

}