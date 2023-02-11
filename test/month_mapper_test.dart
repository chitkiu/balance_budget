import 'package:balance_budget/common/data/month_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Quarter test', () {
    test('Jan to 1 q', () {
      expect(MonthMapper.monthToQuarter(1), equals(1));
    });
    test('Feb to 1 q', () {
      expect(MonthMapper.monthToQuarter(2), equals(1));
    });
    test('Mar to 1 q', () {
      expect(MonthMapper.monthToQuarter(3), equals(1));
    });
    test('Apr to 2 q', () {
      expect(MonthMapper.monthToQuarter(4), equals(2));
    });
    test('May to 2 q', () {
      expect(MonthMapper.monthToQuarter(5), equals(2));
    });
    test('Jun to 2 q', () {
      expect(MonthMapper.monthToQuarter(6), equals(2));
    });
    test('Jul to 3 q', () {
      expect(MonthMapper.monthToQuarter(7), equals(3));
    });
    test('Agu to 3 q', () {
      expect(MonthMapper.monthToQuarter(8), equals(3));
    });
    test('Sep to 3 q', () {
      expect(MonthMapper.monthToQuarter(9), equals(3));
    });
    test('Oct to 4 q', () {
      expect(MonthMapper.monthToQuarter(10), equals(4));
    });
    test('Nov to 4 q', () {
      expect(MonthMapper.monthToQuarter(11), equals(4));
    });
    test('Dec to 4 q', () {
      expect(MonthMapper.monthToQuarter(12), equals(4));
    });
  });
  group('Semi-year test', () {
    test('Jan to 1 sy', () {
      expect(MonthMapper.monthToSemiYear(1), equals(1));
    });
    test('Feb to 1 sy', () {
      expect(MonthMapper.monthToSemiYear(2), equals(1));
    });
    test('Mar to 1 sy', () {
      expect(MonthMapper.monthToSemiYear(3), equals(1));
    });
    test('Apr to 1 sy', () {
      expect(MonthMapper.monthToSemiYear(4), equals(1));
    });
    test('May to 1 sy', () {
      expect(MonthMapper.monthToSemiYear(5), equals(1));
    });
    test('Jun to 1 sy', () {
      expect(MonthMapper.monthToSemiYear(6), equals(1));
    });
    test('Jul to 2 sy', () {
      expect(MonthMapper.monthToSemiYear(7), equals(2));
    });
    test('Agu to 2 sy', () {
      expect(MonthMapper.monthToSemiYear(8), equals(2));
    });
    test('Sep to 2 sy', () {
      expect(MonthMapper.monthToSemiYear(9), equals(2));
    });
    test('Oct to 2 sy', () {
      expect(MonthMapper.monthToSemiYear(10), equals(2));
    });
    test('Nov to 2 sy', () {
      expect(MonthMapper.monthToSemiYear(11), equals(2));
    });
    test('Dec to 2 sy', () {
      expect(MonthMapper.monthToSemiYear(12), equals(2));
    });
  });
}