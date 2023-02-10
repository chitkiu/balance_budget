import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../translator_extension.dart';
import '../domain/accounts_controller.dart';

class AccountsScreen extends CommonScaffoldWithButtonScreen<AccountsController> {
  AccountsScreen({Key? key}) : super(
      Get.localisation.accountsTitle,
      cupertinoIcon: CupertinoIcons.add,
      materialIcon: Icons.add,
      key: key
  );

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      var accounts = controller.accounts;
      return ListView.builder(
        itemBuilder: (context, index) {
          var account = accounts[index];
          return Row(
            children: [
              Text(account.name)
            ],
          );
        },
        itemCount: accounts.length,
      );
    });
  }

  @override
  void onButtonPress() {
    controller.onAddClick();
  }

}