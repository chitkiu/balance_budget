import 'dart:ui';

import 'transaction_ui_model.dart';

class TransactionHeaderUIModel {
  final String title;
  final String sum;
  final Color sumColor;
  final Iterable<TransactionUIModel> transactions;

  const TransactionHeaderUIModel(
      this.title, this.sum, this.sumColor, this.transactions);
}
