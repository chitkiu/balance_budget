import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../common/ui/custom_calendar/calendar.dart';
import '../domain/transactions_controller.dart';
import 'models/transaction_ui_model.dart';

class TransactionsScreen extends CommonScaffoldWithButtonScreen<TransactionsController> {
  TransactionsScreen({super.key}) : super(Get.localisation.transactionsTabName, icon: CommonIcons.add);

  @override
  Widget body(BuildContext context) {
    return Calendar2(
      contentPerDayBuilder: (date) {
        return Obx(() {
          var items = controller.getItemsFromDay(date);
          if (items.isEmpty) {
            return Center(
              child: Text(Get.localisation.noTransactions),
            );
          }
          return SingleChildScrollView(
            child: _transactionItems(items),
          );
        });
      },
      minDay: DateTime(1990),
      maxDay: DateTime(2050),
      initialDay: DateTime.now(),
    );
  }

  @override
  void onButtonPress() {
    controller.addTransaction();
  }

  Widget _transactionItems(List<TransactionUIModel> transactions) {
    List<Widget> children = [];
    Divider divider = const Divider();
    for (int i = 0; i < transactions.length; i++) {
      children.add(_transactionItem(transactions[i]));
      if (i < transactions.length - 1) {
        children.add(divider);
      }
    }
    return Column(
      children: children,
    );
  }

  Widget _transactionItem(TransactionUIModel transaction) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => controller.onItemClick(transaction),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(transaction.categoryName,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text(transaction.sum,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: transaction.sumColor)),
                ],
              ),
              _additionalInfo(transaction.accountName, CommonIcons.wallet),
              if (transaction.comment != null)
                _additionalInfo(transaction.comment!, CommonIcons.note),
            ],
          ),
        ));
  }

  Widget _additionalInfo(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }
}
