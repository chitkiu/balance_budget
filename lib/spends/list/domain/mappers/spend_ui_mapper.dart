import 'package:intl/intl.dart';

import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/spend.dart';
import '../../data/models/rich_spend_model.dart';
import '../../ui/models/grouped_spend_ui_model.dart';
import '../../ui/models/spend_ui_model.dart';

class SpendUIMapper {
  final DateFormat _format = DateFormat('dd-MM-yyyy');

  SpendUIModel map(Spend spend, Category category, Account account) {
    return SpendUIModel(
      sum: spend.sum.toString(),
      categoryName: category.title,
      accountName: account.name,
      time: spend.time.toString(),
      comment: spend.comment,
    );
  }

  SpendUIModel mapFromRich(RichSpendModel richSpend) {
    return map(richSpend.spend, richSpend.category, richSpend.account);
  }

  List<GroupedSpendUIModel> mapGroup(List<RichSpendModel> richSpend) {
    richSpend.sort(_compare);

    Map<String, List<RichSpendModel>> items =
        _groupBy(richSpend, (p0) => _format.format(p0.spend.time));

    return items.entries.map((e) {
      var items = e.value;
      items.sort(_compare);
      return GroupedSpendUIModel(
        e.key,
        items.map(mapFromRich).toList(),
      );
    }).toList();
  }

  int _compare(RichSpendModel a, RichSpendModel b) {
    return b.spend.time.compareTo(a.spend.time);
  }

  Map<T, List<S>> _groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}
