import 'transaction_ui_model.dart';

class GroupedTransactionsUIModel {
  final String title;
  final DateTime dateTime;
  final List<TransactionUIModel> transactions;

  GroupedTransactionsUIModel(this.title, this.dateTime, this.transactions);
}