import 'package:json_annotation/json_annotation.dart';

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

class BudgetDateConverter implements JsonConverter<BudgetDate, Map<String, dynamic>> {
  const BudgetDateConverter();

  @override
  BudgetDate fromJson(Map<String, dynamic> json) => BudgetDate(
    year: json['year'] as int,
    month: json['month'] as int,
    day: json['day'] as int?,
  );

  @override
  Map<String, dynamic> toJson(BudgetDate instance) => <String, dynamic>{
    'year': instance.year,
    'month': instance.month,
    'day': instance.day,
  };
}