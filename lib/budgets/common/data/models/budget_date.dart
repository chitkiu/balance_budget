
import '../../../../common/data/month_mapper.dart';

class BudgetDate {
  final int year;
  final int month;
  final int? day;

  const BudgetDate({required this.year, required this.month, this.day});

  int get quarter => MonthMapper.monthToQuarter(month);
  int get semiYear => MonthMapper.monthToSemiYear(month);

  static BudgetDate fromNow() {
    DateTime now = DateTime.now();
    return BudgetDate(
      year: now.year,
      month: now.month,
      day: now.day,
    );
  }
}