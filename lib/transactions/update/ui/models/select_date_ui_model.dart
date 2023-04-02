class SelectDayUIModel {
  final DateTime dateTime;
  final bool isToday;
  final bool isYesterday;

  SelectDayUIModel(this.dateTime, {required this.isToday, required this.isYesterday});

  static SelectDayUIModel now() {
    return SelectDayUIModel(
      DateTime.now(),
      isYesterday: false,
      isToday: true,
    );
  }
}