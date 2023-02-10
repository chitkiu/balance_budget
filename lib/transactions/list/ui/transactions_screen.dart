import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../translator_extension.dart';
import '../domain/transactions_controller.dart';
import 'models/grouped_transactions_ui_model.dart';
import 'models/transaction_ui_model.dart';

class TransactionsScreen extends CommonScaffoldWithButtonScreen<TransactionsController> {
  TransactionsScreen({Key? key}) : super(
      Get.localisation.transactionsTabName,
      cupertinoIcon: CupertinoIcons.add,
      materialIcon: Icons.add,
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

        //TODO Add cross-platform icons
        if (isExpanded) {
          titleIcon = Icons.keyboard_arrow_up_sharp;
        } else {
          titleIcon = Icons.keyboard_arrow_down_sharp;
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

  Widget _transactionItem(TransactionUIModel spend) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(spend.categoryName,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(spend.sum,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        Text(spend.time),
        if (spend.comment != null) Text("Comment: ${spend.comment}"),
      ],
    );
  }
}
