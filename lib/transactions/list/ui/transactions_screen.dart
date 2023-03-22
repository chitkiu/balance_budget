import 'package:balance_budget/common/ui/custom_calendar/calendar_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/custom_calendar/calendar.dart';
import '../domain/transactions_controller.dart';
import 'models/transaction_ui_model.dart';

class TransactionsScreen extends GetView<TransactionsController> {

  final CalendarController _calendarController = CalendarController(
      DateTime.now(),
    minDate: DateTime(1990),
    maxDate: DateTime(2050),
  );

  TransactionsScreen({super.key}) : super();

  Widget body(BuildContext context) {
    return Calendar2(
      contentPerDayBuilder: (date) {
        return Obx(() {
          var items = controller.getItemsFromDay(date);
          if (items.isEmpty) {
            return Center(
              child: Text("$date"),
              // child: Text(Get.localisation.noTransactions),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: _transactionItems(items),
            ),
          );
        });
      },
      controller: _calendarController,
    );
  }

  @override
  void onButtonPress() {
    controller.addTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SafeArea(
        child: body(context),
      ),
      cupertino: (context, platform) {
        return CupertinoPageScaffoldData(
          navigationBar: CupertinoNavigationBar(
            trailing: CupertinoButton(
              onPressed: onButtonPress,
              child: Icon(CommonIcons.add),
            ),
            middle: Text(Get.localisation.transactionsTabName),
          )
        );
      },
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
              onPressed: onButtonPress,
              child: Icon(CommonIcons.add),
            ),
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: Text(Get.localisation.transactionsTabName),
                  )
                ];
              },
              body: body(context)
          )
        );
      },
    );
  }

  List<Widget> _transactionItems(List<TransactionUIModel> transactions) {
    List<Widget> children = [];
    Divider divider = const Divider();
    for (int i = 0; i < transactions.length; i++) {
      children.add(_transactionItem(transactions[i]));
      if (i < transactions.length - 1) {
        children.add(divider);
      }
    }
    return children;
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
