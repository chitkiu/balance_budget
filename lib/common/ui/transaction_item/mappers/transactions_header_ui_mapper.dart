import 'package:balance_budget/common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import 'package:collection/collection.dart';

import '../../../../transactions/common/data/models/rich_transaction_model.dart';
import '../../../../transactions/common/data/rich_transaction_comparator.dart';
import '../models/complex_transactions_ui_model.dart';
import '../models/transaction_header_ui_model.dart';

class TransactionsHeaderUIMapper {
  final RichTransactionComparator _richTransactionComparator;
  final TransactionsUIMapper _transactionsUIMapper;

  const TransactionsHeaderUIMapper(
      this._richTransactionComparator, this._transactionsUIMapper);

  ComplexTransactionsUIModel mapTransactionsToUI(
      List<RichTransactionModel> filteredTransaction) {
    List<TransactionHeaderUIModel> groupedTransactions = [];

    var totalTransactionCount = 0;

    groupBy(filteredTransaction, (item) => item.transaction.time)
        .entries
        .sortedBy((element) => element.key)
        .reversed
        .forEach((element) {
      var transactions = element.value;
      transactions.sort(_richTransactionComparator.compare);
      var transactionsUIModels =
      transactions.map(_transactionsUIMapper.mapFromRich).whereNotNull();
      if (transactionsUIModels.isNotEmpty) {
        totalTransactionCount += transactionsUIModels.length;
        groupedTransactions.add(_transactionsUIMapper.mapHeader(
            element.key, transactions, transactionsUIModels));
      }
    });

    return ComplexTransactionsUIModel(
        totalTransactionCount, groupedTransactions);
  }
}
