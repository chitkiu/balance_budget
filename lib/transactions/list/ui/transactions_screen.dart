import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../translator_extension.dart';
import '../domain/transactions_controller.dart';
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
          var grouped = transactions[index];
          return Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(grouped.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 8,
              ),
              _transactionItems(grouped.transactions),
            ],
          );
        },
        itemCount: transactions.length,
      );
    });
  }

  @override
  void onButtonPress() {
    controller.addTransaction();
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
            Text(
                spend.sum, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        Text(spend.time),
        if (spend.comment != null) Text("Comment: ${spend.comment}"),
      ],
    );
  }
}
