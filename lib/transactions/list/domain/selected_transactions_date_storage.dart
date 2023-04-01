import 'package:get/get.dart';

import 'models/transactions_filter_date.dart';

class SelectedTransactionsDateStorage {
  late final Rx<TransactionsFilterDate> currentDate;

  SelectedTransactionsDateStorage() {
    DateTime now = DateTime.now();

    currentDate = TransactionsFilterDate(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    ).obs;
  }
}
