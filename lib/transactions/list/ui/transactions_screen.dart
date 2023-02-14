import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../domain/transactions_controller.dart';
import 'models/transaction_ui_model.dart';

class TransactionsScreen extends CommonScaffoldWithButtonScreen<TransactionsController> {
  TransactionsScreen({Key? key})
      : super(Get.localisation.transactionsTabName, icon: CommonIcons.add, key: key);

  final Rx<DateTime> dateTime = DateTime.now().obs;

  @override
  Widget body(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TimelineCalendar(
          calendarType: CalendarType.GREGORIAN,
          calendarLanguage: "en",
          calendarOptions: CalendarOptions(
            viewType: ViewType.DAILY,
            toggleViewType: true,
            headerMonthElevation: 10,
            headerMonthShadowColor: Colors.black26,
            headerMonthBackColor: Colors.transparent,
          ),
          dayOptions: DayOptions(
              compactMode: true, weekDaySelectedColor: const Color(0xff3AC3E2)),
          headerOptions: HeaderOptions(
              weekDayStringType: WeekDayStringTypes.SHORT,
              monthStringType: MonthStringTypes.FULL,
              backgroundColor: Colors.white /*const Color(0xff3AC3E2)*/,
              headerTextColor: Colors.black),
          onChangeDateTime: (datetime) {
            dateTime.value = DateTime(datetime.year, datetime.month, datetime.day);
          },
        ),
        Expanded(child: Obx(() {
          var transactions = controller.getItemsFromMonth(dateTime.value);

          return ListView.separated(
              itemBuilder: (context, index) {
                return _transactionItem(transactions[index]);
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: transactions.length,
          );
        }))
      ],
    );
  }

  @override
  void onButtonPress() {
    controller.addTransaction();
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
              Text(transaction.sum, style: const TextStyle(fontWeight: FontWeight.w500)),
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
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }
}
