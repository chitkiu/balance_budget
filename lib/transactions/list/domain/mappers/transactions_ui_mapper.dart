import 'package:intl/intl.dart';

import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/transaction.dart';
import '../../data/models/rich_transaction_model.dart';
import '../../ui/models/grouped_transactions_ui_model.dart';
import '../../ui/models/transaction_ui_model.dart';

class TransactionsUIMapper {
  final DateFormat _format = DateFormat('dd-MM-yyyy');

  TransactionUIModel map(Transaction transaction, Category category, Account account) {
    return TransactionUIModel(
      id: transaction.id,
      sum: transaction.sum.toString(),
      categoryName: category.title,
      accountName: account.name,
      time: transaction.time.toString(),
      comment: transaction.comment,
    );
  }

  TransactionUIModel mapFromRich(RichTransactionModel richTransaction) {
    return map(richTransaction.transaction, richTransaction.category, richTransaction.account);
  }

  List<GroupedTransactionsUIModel> mapGroup(List<RichTransactionModel> richTransactions) {
    Map<DateTime, List<RichTransactionModel>> items =
        _groupBy(richTransactions, (p0) {
          var date = p0.transaction.time;
          return DateTime(date.year, date.month, date.day);
        });

    return items.entries.map((e) {
      var items = e.value;
      items.sort(_compare);
      return GroupedTransactionsUIModel(
        _format.format(e.key),
        e.key,
        items.map(mapFromRich).toList(),
      );
    }).toList();
  }

  int _compare(RichTransactionModel a, RichTransactionModel b) {
    var result = b.transaction.time.compareTo(a.transaction.time);
    if (result == 0) {
      return b.transaction.creationTime.compareTo(a.transaction.creationTime);
    }
    return result;
  }

  Map<T, List<S>> _groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}
