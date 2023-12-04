import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../common/ui/common_icons.dart';
import '../domain/models/transactions_filter_date.dart';
import '../domain/transactions_cubit.dart';

final DateFormat _appBarDateFormatter = DateFormat("dd, MMM");

class TransactionsCalendarButton extends StatelessWidget {
  final TransactionsFilterDate currentDate;

  const TransactionsCalendarButton(this.currentDate, {super.key});

  @override
  Widget build(BuildContext context) {
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
                  '${_appBarDateFormatter.format(currentDate.start)} - ${_appBarDateFormatter.format(currentDate.end)}',
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
          currentDate.start,
          currentDate.end,
        ]))
        ?.whereNotNull()
        .toList();

    if (result != null) {
      context.read<TransactionsCubit>().setNewDate(result);
    }
  }
}
