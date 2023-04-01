import 'package:balance_budget/transactions/list/domain/transactions_controller.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/ui/common_icons.dart';
import '../domain/models/transactions_filter_date.dart';
import 'items/transaction_item.dart';
import 'models/transaction_header_ui_model.dart';
import 'models/transaction_list_ui_model.dart';
import 'models/transaction_ui_model.dart';

abstract class BaseTransactionsWidget extends GetView<TransactionsController> {
  final DateFormat _appBarDateFormatter = DateFormat("dd, MMM");

  BaseTransactionsWidget({super.key});

  @protected
  Widget mapTransactionToUI(BuildContext context, TransactionListUIModel item) {
    Widget widget;
    if (item is TransactionHeaderUIModel) {
      widget = Text(
        item.title,
        style:
        Theme.of(context).textTheme.titleSmall,
      );
    } else if (item is TransactionUIModel) {
      widget = TransactionItem(item, controller.onItemClick);
    } else {
      widget = Container();
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          8, 0, 8, 0),
      child: widget,
    );
  }

  @protected
  Future<void> changeDate(BuildContext context) async {

    var result = (await showCalendarDatePicker2Dialog(
        context: context,
        config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range,
          firstDayOfWeek: DateTime.monday,
        ),
        dialogSize: const Size(325, 400),
        value: [controller.currentDate.value.start, controller.currentDate.value.end]))
        ?.whereNotNull()
        .toList();

    if (result != null) {
      if (result.length == 1) {
        controller.setNewDate(TransactionsFilterDate(
          start: result.first,
          end: result.first,
        ));
      } else if (result.length == 2) {
        controller.setNewDate(TransactionsFilterDate(
          start: result.first,
          end: result[1],
        ));
      }
    }
  }

  @protected
  Widget calendarButton(BuildContext context) {
    return GestureDetector(
      onTap: () => changeDate(context),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              CommonIcons.calendar,
              size: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Obx(() {
                  var currentDate = controller.currentDate.value;
                  return Text(
                    '${_appBarDateFormatter.format(currentDate.start)} - ${_appBarDateFormatter.format(currentDate.end)}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      letterSpacing: -0.2,
                    ),
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

}
