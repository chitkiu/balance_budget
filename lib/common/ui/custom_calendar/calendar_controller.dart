import 'package:balance_budget/common/data/date_time_extension.dart';
import 'package:flutter/widgets.dart';

class CalendarController extends ChangeNotifier {
  DateTime _currentDate;
  late final DateTime maxDate;
  late final DateTime minDate;
  late final int totalDays;
  late int _currentIndex;

  late final PageController pageController;

  DateTime get currentDate => _currentDate;
  int get currentIndex => _currentIndex;

  CalendarController(this._currentDate, {
    required this.maxDate,
    required this.minDate,
  }) {
    assert(
    !maxDate.isBefore(minDate),
    "Minimum date should be less than maximum date.\n"
        "Provided minimum date: $minDate, maximum date: $maxDate",
    );

    totalDays = maxDate.getDayDifference(minDate) + 1;

    if (_currentDate.isBefore(minDate)) {
      _currentDate = minDate;
    } else if (_currentDate.isAfter(maxDate)) {
      _currentDate = maxDate;
    }

    _currentIndex = _currentDate.getDayDifference(minDate);

    pageController = PageController(initialPage: _currentIndex);
  }

  void setDate(DateTime newDateTime) {
    _currentDate = newDateTime.withoutTime;
    notifyListeners();
  }

  void changeIndex(int index) {
    _currentDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day + (index - _currentIndex),
    );

    _currentIndex = index;

    pageController.jumpToPage(_currentIndex);

    notifyListeners();
  }


}