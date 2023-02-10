import 'package:intl/intl.dart';

import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../../common/data/models/transaction_type.dart';
import '../../../common/data/models/transaction.dart';
import '../../data/models/rich_transaction_model.dart';
import '../../ui/models/grouped_transactions_ui_model.dart';
import '../../ui/models/transaction_ui_model.dart';

class TransactionsUIMapper {
  final DateFormat _format = DateFormat('dd-MM-yyyy');

  TransactionUIModel map(Transaction spend, Category category, Account account) {
    var sumPrefix = "-";
    if (spend.transactionType == TransactionType.income) {
      sumPrefix = "+";
    }
    return TransactionUIModel(
      sum: sumPrefix+spend.sum.toString(),
      categoryName: category.title,
      accountName: account.name,
      time: spend.time.toString(),
      comment: spend.comment,
    );
  }

  TransactionUIModel mapFromRich(RichTransactionModel richSpend) {
    return map(richSpend.transaction, richSpend.category, richSpend.account);
  }

  List<GroupedTransactionsUIModel> mapGroup(List<RichTransactionModel> richSpend) {
    richSpend.sort(_compare);

    Map<String, List<RichTransactionModel>> items =
        _groupBy(richSpend, (p0) => _format.format(p0.transaction.time));

    return items.entries.map((e) {
      var items = e.value;
      items.sort(_compare);
      return GroupedTransactionsUIModel(
        e.key,
        items.map(mapFromRich).toList(),
      );
    }).toList();
  }

  int _compare(RichTransactionModel a, RichTransactionModel b) {
    return b.transaction.time.compareTo(a.transaction.time);
  }

  Map<T, List<S>> _groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}
