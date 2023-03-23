import 'package:balance_budget/common/data/date_time_extension.dart';
import 'package:balance_budget/common/ui/custom_calendar/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'calendar_header.dart';

typedef ContentBuilder = Widget Function(DateTime date);

typedef CalendarPageChangeCallBack = void Function(DateTime date, int page);

class Calendar2 extends StatefulWidget {
  final CalendarController controller;

  /// Page transition duration used when user try to change page using
  /// [DayViewState.nextPage] or [DayViewState.previousPage]
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using
  /// [DayViewState.nextPage] or [DayViewState.previousPage]
  final Curve pageTransitionCurve;

  /// Background colour of day view page.
  final Color? backgroundColor;

  /// Display full day event builder.
  final ContentBuilder contentPerDayBuilder;

  final Widget? additionalBody;

  /// Main widget for day view.
  const Calendar2({
    Key? key,
    required this.controller,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.backgroundColor = Colors.white,
    this.additionalBody,
    required this.contentPerDayBuilder,
  }) : super(key: key);

  @override
  DayViewState createState() => DayViewState();
}

class DayViewState extends State<Calendar2> {

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.controller.pageController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _defaultDayBuilder(widget.controller.currentDate),
              if (widget.additionalBody != null)
                ...[widget.additionalBody!]
            ],
          ),
        ),
      ),
    );
  }

  /// Default view header builder. This builder will be used if
  /// [widget.dayTitleBuilder] is null.
  ///
  Widget _defaultDayBuilder(DateTime date) {
    return CalendarHeader(
      date: date,
      onTitleClick: () async {
        //TODO Add translate
        final selectedDate = await showPlatformDatePicker(
          context: context,
          initialDate: date,
          firstDate: widget.controller.minDate,
          lastDate: widget.controller.maxDate,
        );

        if (selectedDate == null) return;
        jumpToDate(selectedDate);
      },
      onItemClick: (selectedDate) {
        animateToDate(selectedDate);
      },
      onNextClick: () {
        jumpToDate(
          date.add(Duration(days: DateTime.daysPerWeek - date.weekday + 1))
        );
      },
      onPrevClick: () {
        jumpToDate(
            date.subtract(Duration(days: date.weekday))
        );
      },
    );
  }

  /// Jumps to page which gives day calendar for [date]
  ///
  ///
  void jumpToDate(DateTime date) {
    if (date.isBefore(widget.controller.minDate) || date.isAfter(widget.controller.maxDate)) {
      throw "Invalid date selected.";
    }
    widget.controller.pageController.jumpToPage(widget.controller.minDate.getDayDifference(date));
  }

  /// Animate to page which gives day calendar for [date].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  ///
  Future<void> animateToDate(DateTime date,
      {Duration? duration, Curve? curve}) async {
    if (date.isBefore(widget.controller.minDate) || date.isAfter(widget.controller.maxDate)) {
      throw "Invalid date selected.";
    }
    await widget.controller.pageController.animateToPage(
      widget.controller.minDate.getDayDifference(date),
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }
}
