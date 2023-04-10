import 'transaction_header_ui_model.dart';

class ComplexTransactionsUIModel {
  final int transactionCount;
  final List<TransactionHeaderUIModel> transactions;

  ComplexTransactionsUIModel(this.transactionCount, this.transactions);
}
