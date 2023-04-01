import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import 'base_transactions_widget.dart';

class CupertinoTransactionsWidget extends BaseTransactionsWidget {
  CupertinoTransactionsWidget({required super.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(Get.localisation.transactionsTabName),
        trailing: GestureDetector(
          onTap: controller.addTransaction,
          child: Icon(CommonIcons.add),
        ),
      ),
      child: Obx(() {
        return StreamBuilder(
            stream: controller.getItemsFromDayRange(controller.currentDate.value),
            builder: (context, snapshot) {
              Widget? body;
              if (!snapshot.hasData) {
                body = const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null || snapshot.data?.isEmpty != false) {
                body = Center(
                  child: Text(Get.localisation.noTransactions),
                );
              }

              if (body == null) {
                var transactions = snapshot.data!;
                body = ListView(
                  shrinkWrap: true,
                  children: transactions
                      .map((item) => mapTransactionToUI(context, item))
                      .toList(),
                );
              }

              return SafeArea(
                  child: Column(
                    children: [
                      _CupertinoFilterWidget(() => calendarButton(context)),
                      Expanded(child: body)
                    ],
                  )
              );
            });
      }),
    );
  }
}

class _CupertinoFilterWidget extends StatelessWidget {
  final Function() calendarButton;

  const _CupertinoFilterWidget(this.calendarButton);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: calendarButton(),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      Get.localisation.filter,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        CommonIcons.filter,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
