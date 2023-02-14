import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/date_time_extension.dart';
import 'select_month.dart';
import 'select_year.dart';
import 'selector_dialog_theme.dart';

class MonthSelectorTheme {
  final Color navigationColor;
  final Color headerTextColor;
  final Color resetDateColor;
  final DateTime selectedDateTime;
  final SelectorDialogTheme dialogTheme;
  final String font;

  MonthSelectorTheme({
    required this.selectedDateTime,
    this.headerTextColor = Colors.black,
    this.resetDateColor = Colors.black,
    this.navigationColor = Colors.black,
    this.font = '',
    this.dialogTheme = const SelectorDialogTheme(),
  });
}

class MonthSelector extends StatelessWidget {
  final Function onDateTimeReset;
  final Function(DateTime selectedYear) onYearChanged;
  final Function(DateTime selectedMonth) onMonthChanged;
  final MonthSelectorTheme data;

  const MonthSelector(
      {super.key,
      required this.onYearChanged,
      required this.onMonthChanged,
      required this.onDateTimeReset,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  onMonthChanged.call(data.selectedDateTime.prevMonth());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: data.navigationColor,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(
                        context,
                            (_) {
                          return LocalSelectMonth(
                            onHeaderChanged: onMonthChanged,
                            monthStyle: data.dialogTheme,
                            currentDate: data.selectedDateTime,
                          );
                        },
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        monthTranslate(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: data.headerTextColor,
                          fontFamily: data.font,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(
                        context,
                            (_) {
                          return LocalSelectYear(
                            onHeaderChanged: onYearChanged,
                            yearStyle: data.dialogTheme,
                            currentDateTime: data.selectedDateTime,
                          );
                        },
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Text(
                      yearTranslate(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: data.headerTextColor,
                        fontFamily: data.font,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //TODO Make it now jumping when change from current month to next/prev
          Row(
            children: [
              if (!isInTodayIndex())
                buildRefreshView(context),
              GestureDetector(
                onTap: () {
                  onMonthChanged.call(data.selectedDateTime.nextMonth());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: data.navigationColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isInTodayIndex() {
    var now = DateTime.now();
    return data.selectedDateTime.year == now.year &&
        data.selectedDateTime.month == now.month;
  }

  Widget buildRefreshView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDateTimeReset.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(
          Icons.restore,
          size: 24,
          color: data.resetDateColor,
        ),
      ),
    );
  }

  String monthTranslate() {
    DateFormat format = DateFormat('MMM');

    return format.format(data.selectedDateTime);
  }

  String yearTranslate() {
    DateFormat format = DateFormat('yyyy');

    return format.format(data.selectedDateTime);
  }

  //TODO Maybe made it cross-platform
  void _showBottomSheet(
      BuildContext context,
      WidgetBuilder builder,
      {
        Color? backgroundColor = Colors.transparent,
      }
  ) {
    showModalBottomSheet(
      backgroundColor: backgroundColor,
      context: context,
      builder: builder,
    );
  }
}
