import '../../../common/ui/transaction_item/models/complex_transactions_ui_model.dart';
import 'models/transactions_filter_date.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState {
  final TransactionsStatus status;
  final TransactionsFilterDate? date;
  final ComplexTransactionsUIModel? model;
  final String? error;

  TransactionsState(this.status, this.model, this.date, this.error);

  TransactionsState copyWith(
      {TransactionsStatus? status,
      ComplexTransactionsUIModel? model,
      TransactionsFilterDate? date,
      String? error}) {
    return TransactionsState(
      status ?? this.status,
      model ?? this.model,
      date ?? this.date,
      error ?? this.error,
    );
  }
}
