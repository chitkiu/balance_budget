import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/ui/common_icons.dart';
import '../../../common/ui/transaction_item/models/transaction_header_ui_model.dart';
import '../../../common/ui/transaction_item/transaction_section_header_widget.dart';
import '../domain/models/transactions_filter_date.dart';
import '../domain/transactions_cubit.dart';

//TODO Improve UI
abstract class BaseTransactionsWidget extends StatelessWidget {
  final DateFormat _appBarDateFormatter = DateFormat("dd, MMM");

  BaseTransactionsWidget({super.key});

  @protected
  Widget mapTransactionToUI(BuildContext context, TransactionHeaderUIModel item) {
    return TransactionSectionHeaderWidget(
      model: item,
      onItemClick: (transaction) {
        context.read<TransactionsCubit>().onItemClick(context, transaction);
      },
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
            value: [
          context.read<TransactionsCubit>().state.date?.start,
          context.read<TransactionsCubit>().state.date?.end
        ]))
        ?.whereNotNull()
        .toList();

    if (result != null) {
      context.read<TransactionsCubit>().setNewDate(result);
    }
  }

  @protected
  Widget calendarButton(BuildContext context, TransactionsFilterDate? currentDate) {
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
                Text(
                  '${_appBarDateFormatter.format(currentDate?.start ?? DateTime.now())} - ${_appBarDateFormatter.format(currentDate?.end ?? DateTime.now())}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
