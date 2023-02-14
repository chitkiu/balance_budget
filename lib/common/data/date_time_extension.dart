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

  DateTime removeSeconds() {
    return DateTime(
        year,
        month,
        day,
        hour,
        minute
    );
  }

}
