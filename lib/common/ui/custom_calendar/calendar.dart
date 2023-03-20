import 'package:balance_budget/common/data/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'calendar_header.dart';

typedef ContentBuilder = Widget Function(DateTime date);

typedef CalendarPageChangeCallBack = void Function(DateTime date, int page);

class Calendar2 extends StatefulWidget {

  /// Determines the lower boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.epochDate] is default.
  final DateTime? minDay;

  /// Determines upper boundary user can scroll.
  ///
  /// If not provided [CalendarConstants.maxDate] is default.
  final DateTime? maxDay;

  /// Defines initial display day.
  ///
  /// If not provided [DateTime.now] is default date.
  final DateTime? initialDay;

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

  /// Main widget for day view.
  const Calendar2({
    Key? key,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.minDay,
    this.maxDay,
    this.initialDay,
    this.backgroundColor = Colors.white,
    required this.contentPerDayBuilder,
  }) : super(key: key);

  @override
  DayViewState createState() => DayViewState();
}

class DayViewState extends State<Calendar2> {
  late DateTime _currentDate;
  late DateTime _maxDate;
  late DateTime _minDate;
  late int _totalDays;
  late int _currentIndex;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _setDateRange();

    _currentDate = (widget.initialDay ?? DateTime.now()).withoutTime;

    _regulateCurrentDate();

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didUpdateWidget(Calendar2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update date range.
    if (widget.minDay != oldWidget.minDay ||
        widget.maxDay != oldWidget.maxDay) {
      _setDateRange();
      _regulateCurrentDate();

      _pageController.jumpToPage(_currentIndex);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
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
              _defaultDayBuilder(_currentDate),
              Expanded(
                child: PageView.builder(
                  itemCount: _totalDays,
                  controller: _pageController,
                  onPageChanged: _onPageChange,
                  itemBuilder: (_, index) {
                    final date = DateTime(
                        _minDate.year, _minDate.month, _minDate.day + index);
                    return widget.contentPerDayBuilder(date);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sets the current date of this month.
  ///
  /// This method is used in initState and onUpdateWidget methods to
  /// regulate current date in Month view.
  ///
  /// If maximum and minimum dates are change then first call _setDateRange
  /// and then _regulateCurrentDate method.
  ///
  void _regulateCurrentDate() {
    if (_currentDate.isBefore(_minDate)) {
      _currentDate = _minDate;
    } else if (_currentDate.isAfter(_maxDate)) {
      _currentDate = _maxDate;
    }

    _currentIndex = _currentDate.getDayDifference(_minDate);
  }

  //TODO Move somewhere
  static final DateTime epochDate = DateTime(1970);
  static final DateTime maxDate = DateTime(275759);

  /// Sets the minimum and maximum dates for current view.
  void _setDateRange() {
    _minDate = (widget.minDay ?? epochDate).withoutTime;
    _maxDate = (widget.maxDay ?? maxDate).withoutTime;

    assert(
    !_maxDate.isBefore(_minDate),
    "Minimum date should be less than maximum date.\n"
        "Provided minimum date: $_minDate, maximum date: $_maxDate",
    );

    _totalDays = _maxDate.getDayDifference(_minDate) + 1;
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
          firstDate: _minDate,
          lastDate: _maxDate,
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

  /// Called when user change page using any gesture or inbuilt functions.
  ///
  void _onPageChange(int index) {
    if (mounted) {
      setState(() {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month,
          _currentDate.day + (index - _currentIndex),
        );
        _currentIndex = index;
      });
    }
  }
  /// Jumps to page which gives day calendar for [date]
  ///
  ///
  void jumpToDate(DateTime date) {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    _pageController.jumpToPage(_minDate.getDayDifference(date));
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
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    await _pageController.animateToPage(
      _minDate.getDayDifference(date),
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }
}
