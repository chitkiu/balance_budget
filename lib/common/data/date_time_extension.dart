import 'month_mapper.dart';

extension DTExtension on DateTime {
  bool isAfterOrAtSameMoment(DateTime compare) {
    return isAfter(compare) || isAtSameMomentAs(compare);
  }

  bool isBeforeOrAtSameMoment(DateTime compare) {
    return isBefore(compare) || isAtSameMomentAs(compare);
  }

  int get quarter => MonthMapper.monthToQuarter(month);

  int get semiYear => MonthMapper.monthToSemiYear(month);

  DateTime nextMonth() {
    return DateTime(year, month + 1, day);
  }

  DateTime prevMonth() {
    return DateTime(year, month - 1, day);
  }
  DateTime nextDay() {
    return add(const Duration(days: 1));
  }

  DateTime prevDay() {
    return subtract(const Duration(days: 1));
  }

  DateTime removeSeconds() {
    return DateTime(
        year,
        month,
        day,
        hour,
        minute
    );
  }

  DateTime get withoutTime => DateTime(year, month, day);

  /// Gets difference of days between [date] and calling object.
  int getDayDifference(DateTime date) => DateTime.utc(year, month, day)
      .difference(DateTime.utc(date.year, date.month, date.day))
      .inDays
      .abs();
}
