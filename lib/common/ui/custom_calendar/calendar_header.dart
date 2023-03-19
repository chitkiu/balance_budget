import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime date;
  final void Function()? onTitleClick;
  final void Function()? onNextClick;
  final void Function()? onPrevClick;
  final void Function(DateTime)? onItemClick;

  const CalendarHeader({
    required this.date,
    this.onTitleClick,
    this.onNextClick,
    this.onPrevClick,
    this.onItemClick,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var week = getDaysInBetween(
        date.subtract(Duration(days: date.weekday - 1)),
        date.add(Duration(days: DateTime.daysPerWeek - date.weekday)),
    );
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (onPrevClick != null) {
                  onPrevClick!();
                }
              },
              icon: const Icon(
                Icons.navigate_before,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (onTitleClick != null) {
                  onTitleClick!();
                }
              },
              //TODO Add month name
              child: Text("Date ${date.month}"),
            ),
            IconButton(
              onPressed: () {
                if (onNextClick != null) {
                  onNextClick!();
                }
              },
              icon: const Icon(
                Icons.navigate_next,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: week.map((e) => _dateItem(e, e == date)).toList(),
        )
      ],
    );
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Widget _dateItem(DateTime date, bool isCurrent) {
    Color backgroundColor = Colors.transparent;
    if (isCurrent) {
      backgroundColor = Colors.blue;
    }
    return GestureDetector(
      onTap: () {
        if (onItemClick != null) {
          onItemClick!(date);
        }
      },
      //TODO Add day of week
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            child: Center(
              child: Text(
                "${date.day}",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
