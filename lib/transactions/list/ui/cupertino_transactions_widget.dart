import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import 'base_transactions_widget.dart';

class CupertinoTransactionsWidget extends BaseTransactionsWidget {
  CupertinoTransactionsWidget({super.key});

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
        child: SafeArea(
            child: Column(
          children: [
            _CupertinoFilterWidget(() => calendarButton(context)),
            Expanded(
                child: controller.obx(
              (transactions) {
                return ListView(
                  children: transactions
                          ?.map((item) => mapTransactionToUI(context, item))
                          .toList() ??
                      [],
                );
              },
              onLoading: const Center(
                child: CircularProgressIndicator(),
              ),
              onEmpty: Center(
                child: Text(Get.localisation.noTransactions),
              ),
            ))
          ],
        )));
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
