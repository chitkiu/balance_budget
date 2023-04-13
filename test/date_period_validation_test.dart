import 'package:balance_budget/budgets/common/data/models/budget_repeat_type.dart';
import 'package:balance_budget/budgets/list/domain/calculators/date_period_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatePeriodValidation one-time test', () {
    DatePeriodValidation validation = const DatePeriodValidation();
    BudgetRepeatType type = BudgetRepeatType.oneTime;

    DateTime start = DateTime(2023, 2, 10);
    DateTime end = DateTime(2023, 2, 16);

    test('Day before start', () {
      DateTime current = DateTime(2023, 2, 9);
      expect(validation.isInCurrentPeriod(current, type, start, end),
          equals(false));
    });

    test('Start day', () {
      DateTime current = DateTime(2023, 2, 10);
      expect(validation.isInCurrentPeriod(current, type, start, end),
          equals(true));
    });

    test('Day in the middle', () {
      DateTime current = DateTime(2023, 2, 13);
      expect(validation.isInCurrentPeriod(current, type, start, end),
          equals(true));
    });

    test('End day', () {
      DateTime current = DateTime(2023, 2, 16);
      expect(validation.isInCurrentPeriod(current, type, start, end),
          equals(true));
    });

    test('Day after end', () {
      DateTime current = DateTime(2023, 2, 17);
      expect(validation.isInCurrentPeriod(current, type, start, end),
          equals(false));
    });
  });

  group('DatePeriodValidation monthly test', () {
    DatePeriodValidation validation = const DatePeriodValidation();
    BudgetRepeatType type = BudgetRepeatType.monthly;

    DateTime start = DateTime(2023, 2);

    test('Month before start', () {
      DateTime current = DateTime(2023, 1);
      expect(validation.isInCurrentPeriod(current, type, start, null),
          equals(false));
    });

    test('Start month', () {
      DateTime current = DateTime(2023, 2);
      expect(validation.isInCurrentPeriod(current, type, start, null),
          equals(true));
    });

    test('After start month', () {
      DateTime current = DateTime(2023, 4);
      expect(validation.isInCurrentPeriod(current, type, start, null),
          equals(true));
    });

    test('Set end month after current', () {
      DateTime end = DateTime(2023, 4);

      DateTime current = DateTime(2023, 3);
      expect(validation.isInCurrentPeriod(current, type, start, end),
          equals(true));
    });

    test('Set end month equals current', () {
      DateTime end = DateTime(2023, 4);

      DateTime current = DateTime(2023, 4);
      expect(validation.isInCurrentPeriod(current, type, start, end),
          equals(true));
    });

    test('Set end month before current', () {
      DateTime end = DateTime(2023, 3);

      DateTime current = DateTime(2023, 4);
      expect(validation.isInCurrentPeriod(current, type, start, end),
          equals(false));
    });
  });

  //TODO Add the same test for other quarters, maybe rewrite this tests
  group('DatePeriodValidation quarter test', () {
    DatePeriodValidation validation = const DatePeriodValidation();
    BudgetRepeatType type = BudgetRepeatType.quarter;

    DateTime firstQuarterStart = DateTime(2023, 1);
    DateTime firstQuarterEnd = DateTime(2023, 3);

    DateTime secondQuarterStart = DateTime(2023, 4);
    DateTime secondQuarterEnd = DateTime(2023, 6);

    // BudgetDate thirdQuarterStart = const BudgetDate(year: 2023, month: 7);
    // BudgetDate thirdQuarterEnd = const BudgetDate(year: 2023, month: 9);
    //
    // BudgetDate fourthQuarterStart = const BudgetDate(year: 2023, month: 10);
    // BudgetDate fourthQuarterEnd = const BudgetDate(year: 2023, month: 12);

    //////////////////////////FIRST QUARTER/////////////////////////////////////
    test('Start in 1 q, current in 1 q', () {
      DateTime current = DateTime(2023, 2, 9);
      expect(
          validation.isInCurrentPeriod(current, type, firstQuarterStart, null),
          equals(true));
    });
    test('Start in 1 q, current in start of 1 q', () {
      DateTime current = DateTime(2023, 1, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstQuarterStart, null),
          equals(true));
    });
    test('Start in 1 q, current in end of 1 q', () {
      DateTime current = DateTime(2023, 3, 31);
      expect(
          validation.isInCurrentPeriod(current, type, firstQuarterStart, null),
          equals(true));
    });
    test('Start in 1 q, current in 2 q', () {
      DateTime current = DateTime(2023, 4, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstQuarterStart, null),
          equals(true));
    });
    test('Start in 1 q, current in 3 q', () {
      DateTime current = DateTime(2023, 7, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstQuarterStart, null),
          equals(true));
    });
    test('Start in 1 q, current in 4 q', () {
      DateTime current = DateTime(2023, 10, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstQuarterStart, null),
          equals(true));
    });
    test('Start in 1 q, current in 1 q next year', () {
      DateTime current = DateTime(2024, 1, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstQuarterStart, null),
          equals(true));
    });
    test('Start in 1 q, current in 1 q prev year', () {
      DateTime current = DateTime(2022, 1, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstQuarterStart, null),
          equals(false));
    });
    test('Start in 1 q, end in 1 q, current in 1 q', () {
      DateTime current = DateTime(2023, 3, 31);
      expect(validation.isInCurrentPeriod(
          current, type, firstQuarterStart, firstQuarterEnd),
          equals(true));
    });
    test('Start in 1 q, end in 1 q, current in 2 q', () {
      DateTime current = DateTime(2023, 4, 1);
      expect(validation.isInCurrentPeriod(
          current, type, firstQuarterStart, firstQuarterEnd),
          equals(false));
    });
    test('Start in 1 q, end in 1 q, current in 1 q prev year', () {
      DateTime current = DateTime(2022, 1, 1);
      expect(validation.isInCurrentPeriod(
          current, type, firstQuarterStart, firstQuarterEnd),
          equals(false));
    });

    //////////////////////////SECOND QUARTER/////////////////////////////////////
    test('Start in 2 q, current in 1 q', () {
      DateTime current = DateTime(2023, 2, 9);
      expect(
          validation.isInCurrentPeriod(current, type, secondQuarterStart, null),
          equals(false));
    });
    test('Start in 2 q, current in start of 2 q', () {
      DateTime current = DateTime(2023, 4, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondQuarterStart, null),
          equals(true));
    });
    test('Start in 2 q, current in end of 2 q', () {
      DateTime current = DateTime(2023, 6, 30);
      expect(
          validation.isInCurrentPeriod(current, type, secondQuarterStart, null),
          equals(true));
    });
    test('Start in 2 q, current in middle of 2 q', () {
      DateTime current = DateTime(2023, 5, 15);
      expect(
          validation.isInCurrentPeriod(current, type, secondQuarterStart, null),
          equals(true));
    });
    test('Start in 2 q, current in 3 q', () {
      DateTime current = DateTime(2023, 7, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondQuarterStart, null),
          equals(true));
    });
    test('Start in 2 q, current in 4 q', () {
      DateTime current = DateTime(2023, 10, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondQuarterStart, null),
          equals(true));
    });
    test('Start in 2 q, current in 2 q next year', () {
      DateTime current = DateTime(2024, 4, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondQuarterStart, null),
          equals(true));
    });
    test('Start in 2 q, current in 2 q prev year', () {
      DateTime current = DateTime(2022, 4, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondQuarterStart, null),
          equals(false));
    });
    test('Start in 2 q, end in 2 q, current in 2 q', () {
      DateTime current = DateTime(2023, 6, 30);
      expect(validation.isInCurrentPeriod(
          current, type, secondQuarterStart, secondQuarterEnd),
          equals(true));
    });
    test('Start in 2 q, end in 2 q, current in 3 q', () {
      DateTime current = DateTime(2023, 7, 1);
      expect(validation.isInCurrentPeriod(
          current, type, secondQuarterStart, secondQuarterEnd),
          equals(false));
    });
    test('Start in 2 q, end in 2 q, current in 1 q prev year', () {
      DateTime current = DateTime(2022, 4, 1);
      expect(validation.isInCurrentPeriod(
          current, type, secondQuarterStart, secondQuarterEnd),
          equals(false));
    });
  });

  //TODO Improve tests
  group('DatePeriodValidation semi-year test', () {
    DatePeriodValidation validation = const DatePeriodValidation();
    BudgetRepeatType type = BudgetRepeatType.semiYear;

    DateTime firstHalfStart = DateTime(2023, 1);
    DateTime firstHalfEnd = DateTime(2023, 6);

    DateTime secondHalfStart = DateTime(2023, 7);
    DateTime secondHalfEnd = DateTime(2023, 12);

    //////////////////////////FIRST QUARTER/////////////////////////////////////
    test('Start in 1 h, current in 1 h', () {
      DateTime current = DateTime(2023, 2, 9);
      expect(
          validation.isInCurrentPeriod(current, type, firstHalfStart, null),
          equals(true));
    });
    test('Start in 1 h, current in start of 1 h', () {
      DateTime current = DateTime(2023, 1, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstHalfStart, null),
          equals(true));
    });
    test('Start in 1 h, current in end of 1 h', () {
      DateTime current = DateTime(2023, 6, 30);
      expect(
          validation.isInCurrentPeriod(current, type, firstHalfStart, null),
          equals(true));
    });
    test('Start in 1 h, current in 2 h', () {
      DateTime current = DateTime(2023, 7, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstHalfStart, null),
          equals(true));
    });
    test('Start in 1 h, current in 2 h', () {
      DateTime current = DateTime(2023, 10, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstHalfStart, null),
          equals(true));
    });
    test('Start in 1 h, current in 1 h next year', () {
      DateTime current = DateTime(2024, 1, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstHalfStart, null),
          equals(true));
    });
    test('Start in 1 h, current in 1 h prev year', () {
      DateTime current = DateTime(2022, 1, 1);
      expect(
          validation.isInCurrentPeriod(current, type, firstHalfStart, null),
          equals(false));
    });
    test('Start in 1 h, end in 1 h, current in 1 h', () {
      DateTime current = DateTime(2023, 3, 31);
      expect(validation.isInCurrentPeriod(
          current, type, firstHalfStart, firstHalfEnd),
          equals(true));
    });
    test('Start in 1 h, end in 1 h, current in 2 h', () {
      DateTime current = DateTime(2023, 7, 1);
      expect(validation.isInCurrentPeriod(
          current, type, firstHalfStart, firstHalfEnd),
          equals(false));
    });
    test('Start in 1 h, end in 1 h, current in 1 h prev year', () {
      DateTime current = DateTime(2022, 1, 1);
      expect(validation.isInCurrentPeriod(
          current, type, firstHalfStart, firstHalfEnd),
          equals(false));
    });

    //////////////////////////SECOND QUARTER/////////////////////////////////////
    test('Start in 2 h, current in 1 h', () {
      DateTime current = DateTime(2023, 2, 9);
      expect(
          validation.isInCurrentPeriod(current, type, secondHalfStart, null),
          equals(false));
    });
    test('Start in 2 h, current in start of 2 h', () {
      DateTime current = DateTime(2023, 7, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondHalfStart, null),
          equals(true));
    });
    test('Start in 2 h, current in end of 2 h', () {
      DateTime current = DateTime(2023, 12, 31);
      expect(
          validation.isInCurrentPeriod(current, type, secondHalfStart, null),
          equals(true));
    });
    test('Start in 2 h, current in middle of 2 h', () {
      DateTime current = DateTime(2023, 10, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondHalfStart, null),
          equals(true));
    });
    test('Start in 2 h, current in 2 h next year', () {
      DateTime current = DateTime(2024, 7, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondHalfStart, null),
          equals(true));
    });
    test('Start in 2 h, current in 2 h prev year', () {
      DateTime current = DateTime(2022, 7, 1);
      expect(
          validation.isInCurrentPeriod(current, type, secondHalfStart, null),
          equals(false));
    });
    test('Start in 2 h, end in h q, current in 2 h', () {
      DateTime current = DateTime(2023, 12, 31);
      expect(validation.isInCurrentPeriod(
          current, type, secondHalfStart, secondHalfEnd),
          equals(true));
    });
    test('Start in 2 h, end in 2 h, current in 1 h prev year', () {
      DateTime current = DateTime(2022, 3, 1);
      expect(validation.isInCurrentPeriod(
          current, type, secondHalfStart, secondHalfEnd),
          equals(false));
    });
    test('Start in 2 h, end in 2 h, current in 2 h prev year', () {
      DateTime current = DateTime(2022, 7, 1);
      expect(validation.isInCurrentPeriod(
          current, type, secondHalfStart, secondHalfEnd),
          equals(false));
    });
  });
}
