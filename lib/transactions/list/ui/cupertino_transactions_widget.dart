import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import 'base_transactions_widget.dart';
import 'filter_popup/filter_dialog.dart';

class CupertinoTransactionsWidget extends BaseTransactionsWidget {
  CupertinoTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(Get.localisation.transactionsTabName),
          trailing: GestureDetector(
            onTap: () => controller.addTransaction(context),
            child: Icon(CommonIcons.add),
          ),
        ),
        child: SafeArea(
            child: Column(
          children: [
            controller.obx(
              (state) {
                return _CupertinoFilterWidget(calendarButton(context));
              },
              onEmpty: _CupertinoFilterWidget(calendarButton(context)),
            ),
            Expanded(
                child: controller.obx(
              (model) {
                return ListView(
                  children: model?.transactions
                          .map((item) => mapTransactionToUI(context, item))
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
  final Widget calendarButton;

  const _CupertinoFilterWidget(this.calendarButton);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 3),
          child: Row(
            children: <Widget>[
              Expanded(
                child: calendarButton,
              ),
              GestureDetector(
                onTap: () => showFilterDialog(context: context),
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
        const Divider(
          height: 1,
          color: Colors.black,
        )
      ],
    );
  }
}
