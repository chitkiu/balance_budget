import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HeaderStyle {
  /// Provide text style for calendar's header.
  final TextStyle? headerTextStyle;

  /// Widget used for left icon.
  ///
  /// Tapping on it will navigate to previous calendar page.
  final Widget? leftIcon;

  /// Widget used for right icon.
  ///
  /// Tapping on it will navigate to next calendar page.
  final Widget? rightIcon;

  /// Determines left icon visibility.
  final bool leftIconVisible;

  /// Determines right icon visibility.
  final bool rightIconVisible;

  /// Internal padding of the whole header.
  final EdgeInsets headerPadding;

  /// External margin of the whole header.
  final EdgeInsets headerMargin;

  /// Internal padding of left icon.
  final EdgeInsets leftIconPadding;

  /// Internal padding of right icon.
  final EdgeInsets rightIconPadding;

  /// Define Alignment of header text.
  final TextAlign titleAlign;

  /// Decoration of whole header.
  final BoxDecoration? decoration;

  /// Create a `HeaderStyle` of calendar view
  const HeaderStyle({
    this.headerTextStyle,
    this.leftIcon,
    this.rightIcon,
    this.leftIconVisible = true,
    this.rightIconVisible = true,
    this.headerMargin = EdgeInsets.zero,
    this.headerPadding = EdgeInsets.zero,
    this.leftIconPadding = const EdgeInsets.all(10),
    this.rightIconPadding = const EdgeInsets.all(10),
    this.titleAlign = TextAlign.center,
    this.decoration = const BoxDecoration(color: Colors.black),
  });
}

class CalendarPageHeader extends StatelessWidget {
  /// When user taps on right arrow.
  final VoidCallback? onNextDay;

  /// When user taps on left arrow.
  final VoidCallback? onPreviousDay;

  /// When user taps on title.
  final AsyncCallback? onTitleTapped;

  /// Date of month/day.
  final DateTime date;

  /// Secondary date. This date will be used when we need to define a
  /// range of dates.
  /// [date] can be starting date and [secondaryDate] can be end date.
  final DateTime? secondaryDate;

  /// Provides string to display as title.
  final String Function(DateTime) dateStringBuilder;

  /// Style for Calendar's header
  final HeaderStyle headerStyle;

  /// Common header for month and day view In this header user can define format
  /// in which date will be displayed by providing [dateStringBuilder] function.
  const CalendarPageHeader({
    Key? key,
    required this.date,
    required this.dateStringBuilder,
    this.onNextDay,
    this.onTitleTapped,
    this.onPreviousDay,
    this.secondaryDate,
    this.headerStyle = const HeaderStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      decoration: headerStyle.decoration,
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (headerStyle.leftIconVisible)
            IconButton(
              onPressed: onPreviousDay,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: headerStyle.leftIconPadding,
              icon: headerStyle.leftIcon ??
                  const Icon(
                    Icons.chevron_left,
                    size: 30,
                    color: Colors.white,
                  ),
            ),
          Expanded(
            child: InkWell(
              onTap: onTitleTapped,
              child: Text(
                dateStringBuilder(date),
                textAlign: headerStyle.titleAlign,
                style: headerStyle.headerTextStyle,
              ),
            ),
          ),
          if (headerStyle.rightIconVisible)
            IconButton(
              onPressed: onNextDay,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: headerStyle.rightIconPadding,
              icon: headerStyle.rightIcon ??
                  const Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: Colors.white,
                  ),
            ),
        ],
      ),
    );
  }
}

class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    String Function(DateTime)? dateStringBuilder,
    required DateTime date,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
    key: key,
    date: date,
    onNextDay: onNextDay,
    onPreviousDay: onPreviousDay,
    onTitleTapped: onTitleTapped,
    dateStringBuilder:
    dateStringBuilder ?? DayPageHeader._dayStringBuilder,
    headerStyle: headerStyle,
  );
  static String _dayStringBuilder(DateTime date) =>
      "${date.day} - ${date.month} - ${date.year}";
}