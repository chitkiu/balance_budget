import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../data/date_time_extension.dart';
import 'calendar_controller.dart';
import 'calendar_header.dart';

typedef ContentBuilder = Widget Function(DateTime date);

typedef CalendarPageChangeCallBack = void Function(DateTime date, int page);

const double kCalendarMaterialHeight = 88.0;
const double kCalendarCupertinoHeight = 96.0;

class Calendar2 extends StatefulWidget {
  final CalendarController controller;

  /// Page transition duration used when user try to change page using
  /// [DayViewState.nextPage] or [DayViewState.previousPage]
  final Duration pageTransitionDuration;

  /// Page transition curve used when user try to change page using
  /// [DayViewState.nextPage] or [DayViewState.previousPage]
  final Curve pageTransitionCurve;

  /// Main widget for day view.
  const Calendar2({
    Key? key,
    required this.controller,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
  }) : super(key: key);

  @override
  DayViewState createState() => DayViewState();
}

class DayViewState extends State<Calendar2> {

  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _listener = () {
      setState(() {});
    };

    widget.controller.addListener(_listener);
  }

  @override
  void didUpdateWidget(Calendar2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_listener);
      widget.controller.addListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PlatformWidget(
      cupertino: (context, platform) {
        return _build(kCalendarCupertinoHeight);
      },
      material: (context, platform) {
        return _build(kCalendarMaterialHeight);
      },
    ));
  }

  Widget _build(double height) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: _defaultDayBuilder(widget.controller.currentDate),
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
        jumpToDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday + 1)));
      },
      onPrevClick: () {
        jumpToDate(date.subtract(Duration(days: date.weekday)));
      },
    );
  }

  /// Jumps to page which gives day calendar for [date]
  ///
  ///
  void jumpToDate(DateTime date) {
    if (date.isBefore(widget.controller.minDate) ||
        date.isAfter(widget.controller.maxDate)) {
      throw "Invalid date selected.";
    }
    widget.controller.pageController
        .jumpToPage(widget.controller.minDate.getDayDifference(date));
  }

  /// Animate to page which gives day calendar for [date].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  ///
  Future<void> animateToDate(DateTime date, {Duration? duration, Curve? curve}) async {
    if (date.isBefore(widget.controller.minDate) ||
        date.isAfter(widget.controller.maxDate)) {
      throw "Invalid date selected.";
    }
    await widget.controller.pageController.animateToPage(
      widget.controller.minDate.getDayDifference(date),
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }
}
