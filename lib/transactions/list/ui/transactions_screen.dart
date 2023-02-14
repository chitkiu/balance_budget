import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
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
    return Padding(
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
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            _additionalInfo(transaction.accountName, CommonIcons.wallet),
            if (transaction.comment != null)
              _additionalInfo(transaction.comment!, CommonIcons.note),
          ],
        ),
    );
  }

  //TODO Maybe remove later
/*  Widget _moreButton(TransactionUIModel transaction) {
    if (PlatformInfo.isCupertino) {
      return PullDownButton(
        itemBuilder: (context) {
          return [
            PullDownMenuItem(
              onTap: () => _requestDeleteTransaction(transaction),
              title: Get.localisation.delete,
              itemTheme: const PullDownMenuItemTheme(
                textStyle: TextStyle(
                  color: Colors.red
                )
              ),
              icon: CupertinoIcons.trash,
              iconColor: Colors.red,
            )
          ];
        },
        buttonBuilder: (context, showMenu) {
          return CupertinoButton(
            onPressed: showMenu,
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.ellipsis_circle),
          );
        },
      );
    } else {
      return PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              child: Text(Get.localisation.delete),
              onTap: () => _requestDeleteTransaction(transaction),
            )
          ];
        },
      );
    }
  }

  Future<void> _requestDeleteTransaction(TransactionUIModel transaction) async {
    await confirmBeforeAction(
          () async {
        await controller.deleteTransaction(transaction.id);
      },
      title: Get.localisation.confirmToDeleteTitle,
      subTitle: Get.localisation.confirmToDeleteText,
      confirmAction: Get.localisation.yes,
      cancelAction: Get.localisation.no,
    );
  }*/

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
          style: const TextStyle(
              fontSize: 14
          ),
        )
      ],
    );
  }
}
