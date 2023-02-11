class MonthMapper {
  static int monthToQuarter(int month) => ((month+2) / 3).floor();
  static int monthToSemiYear(int month) => ((month+5) / 6).floor();
}