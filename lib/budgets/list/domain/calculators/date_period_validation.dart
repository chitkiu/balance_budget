import '../../../../common/data/date_time_extension.dart';
import '../../../common/data/models/budget_repeat_type.dart';

class DatePeriodValidation {
  const DatePeriodValidation();

  bool isInCurrentPeriod(DateTime current, BudgetRepeatType repeatType,
      DateTime start, DateTime? end) {
    switch (repeatType) {
      case BudgetRepeatType.oneTime:
        return _checkPeriod(current, start, end);

      case BudgetRepeatType.monthly:
        DateTime currentDT = DateTime(current.year, current.month);
        DateTime startDT = DateTime(start.year, start.month);
        DateTime? endDT;
        if (end != null) {
          endDT = DateTime(end.year, end.month);
        }
        return _checkPeriod(currentDT, startDT, endDT);

      case BudgetRepeatType.quarter:
        bool isAfterOrSameAsStart = current.year >= start.year && current.quarter >= start.quarter;
        if (end != null) {
          bool isBeforeOrSameAsEnd = current.year <= end.year && current.quarter <= end.quarter;
          return isAfterOrSameAsStart && isBeforeOrSameAsEnd;
        }
        return isAfterOrSameAsStart;

      case BudgetRepeatType.semiYear:
        bool isAfterOrSameAsStart = current.year >= start.year && current.semiYear >= start.semiYear;
        if (end != null) {
          bool isBeforeOrSameAsEnd = current.year <= end.year && current.semiYear <= end.semiYear;
          return isAfterOrSameAsStart && isBeforeOrSameAsEnd;
        }
        return isAfterOrSameAsStart;

      case BudgetRepeatType.year:
        DateTime currentDT = DateTime(current.year);
        DateTime startDT = DateTime(start.year);
        DateTime? endDT;
        if (end != null) {
          endDT = DateTime(end.year);
        }
        return _checkPeriod(currentDT, startDT, endDT);
    }
  }

  bool _checkPeriod(DateTime current, DateTime start, DateTime? end) {
    if (current.isAfterOrAtSameMoment(start)) {
      return end == null ||
          current.isBeforeOrAtSameMoment(end);
    } else {
      return false;
    }
  }

}
