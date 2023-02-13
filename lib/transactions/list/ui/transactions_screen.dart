import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../translator_extension.dart';
import '../domain/transactions_controller.dart';
import 'models/grouped_transactions_ui_model.dart';
import 'models/transaction_ui_model.dart';

class TransactionsScreen extends CommonScaffoldWithButtonScreen<TransactionsController> {
  TransactionsScreen({Key? key}) : super(
      Get.localisation.transactionsTabName,
      icon: CommonIcons.add,
      key: key
  );

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      var transactions = controller.transactions;
      return ListView.builder(
        itemBuilder: (context, index) {
          return _groupedItems(transactions[index]);
        },
        itemCount: transactions.length,
      );
    });
  }

  @override
  void onButtonPress() {
    controller.addTransaction();
  }

  Widget _groupedItems(GroupedTransactionsUIModel grouped) {
    return ValueBuilder<bool>(
      initialValue: true,
      builder: (bool? value, updater) {
        bool isExpanded = value == true;
        IconData titleIcon;

        if (isExpanded) {
          titleIcon = CommonIcons.arrowUp;
        } else {
          titleIcon = CommonIcons.arrowDown;
        }
        return Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(grouped.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Icon(titleIcon),
                ],
              ),
              onTap: () {
                if (value != null) {
                  updater(!value);
                }
              },
            ),
            if (isExpanded) _transactionItems(grouped.transactions),
          ],
        );
      },
    );
  }

  Widget _transactionItems(List<TransactionUIModel> transactions) {
    return Column(
      children: transactions.map(_transactionItem).toList(),
    );
  }

  Widget _transactionItem(TransactionUIModel transaction) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(transaction.categoryName,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(transaction.sum,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            PlatformIconButton(
              icon: Icon(Icons.more_horiz), //TODO Made cross-platform
              onPressed: () async {
                //TODO Replace to call context menu for choose action
                await confirmBeforeAction(
                  () async {
                    await controller.deleteTransaction(transaction.id);
                  },
                  title: Get.localisation.confirmToDeleteTitle,
                  subTitle: Get.localisation.confirmToDeleteText,
                  confirmAction: Get.localisation.yes,
                  cancelAction: Get.localisation.no,
                );
              },
            )
          ],
        ),
        Text(transaction.time),
        if (transaction.comment != null) Text("Comment: ${transaction.comment}"),
      ],
    );
  }
}
