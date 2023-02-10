import 'transaction_ui_model.dart';

class GroupedTransactionsUIModel {
  final String title;
  final List<TransactionUIModel> transactions;

  GroupedTransactionsUIModel(this.title, this.transactions);
}