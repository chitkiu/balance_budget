import 'package:rxdart/subjects.dart';

import 'models/transactions_filter_date.dart';

class SelectedTransactionsDateStorage {
  final currentDateStream = BehaviorSubject<TransactionsFilterDate>();

  SelectedTransactionsDateStorage() {
    DateTime now = DateTime.now();

    currentDateStream.value = TransactionsFilterDate(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
  }

  void setNewDate(TransactionsFilterDate date) {
    currentDateStream.value = date;
  }
}
