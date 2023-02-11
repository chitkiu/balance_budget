import '../../../../common/data/date_time_extension.dart';
import '../../../common/data/models/budget_date.dart';
import '../../../common/data/models/budget_repeat_type.dart';

class DatePeriodValidation {
  const DatePeriodValidation();

  bool isInCurrentPeriod(DateTime time, BudgetRepeatType repeatType,
      BudgetDate start, BudgetDate? end) {
    switch (repeatType) {
      case BudgetRepeatType.oneTime:
        DateTime currentDT = DateTime(time.year, time.month, time.day);
        DateTime startDT = DateTime(start.year, start.month, start.day ?? 1);
        DateTime? endDT;
        if (end != null) {
          endDT = DateTime(end.year, end.month, end.day ?? 1);
        }
        return _checkPeriod(currentDT, startDT, endDT);

      case BudgetRepeatType.monthly:
        DateTime currentDT = DateTime(time.year, time.month);
        DateTime startDT = DateTime(start.year, start.month);
        DateTime? endDT;
        if (end != null) {
          endDT = DateTime(end.year, end.month);
        }
        return _checkPeriod(currentDT, startDT, endDT);

      case BudgetRepeatType.quarter:
        bool isAfterOrSameAsStart = time.year >= start.year && time.quarter >= start.quarter;
        if (end != null) {
          bool isBeforeOrSameAsEnd = time.year <= end.year && time.quarter <= end.quarter;
          return isAfterOrSameAsStart && isBeforeOrSameAsEnd;
        }
        return isAfterOrSameAsStart;

      case BudgetRepeatType.semiYear:
        bool isAfterOrSameAsStart = time.year >= start.year && time.semiYear >= start.semiYear;
        if (end != null) {
          bool isBeforeOrSameAsEnd = time.year <= end.year && time.semiYear <= end.semiYear;
          return isAfterOrSameAsStart && isBeforeOrSameAsEnd;
        }
        return isAfterOrSameAsStart;

      case BudgetRepeatType.year:
        DateTime currentDT = DateTime(time.year);
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
