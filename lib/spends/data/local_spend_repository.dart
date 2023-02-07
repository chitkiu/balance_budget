import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../categories/data/models/category_id.dart';
import 'models/spend.dart';
import 'models/spend_id.dart';

class LocalSpendRepository {
  final _uuid = const Uuid();
  final List<Spend> _spends = [];

  void create(double sum, CategoryId categoryId, DateTime time, String? comment) {
    _spends.add(Spend(
      id: SpendId(_uuid.v4()),
      sum: sum,
      categoryId: categoryId,
      time: time,
      comment: comment,
    ));
  }

  List<Spend> getAllSpends() {
    return _spends;
  }

  void remove(SpendId spend) {
    _spends.removeWhere((element) => element.id == spend);
  }

  void edit(SpendId spend, double? sum, CategoryId? categoryId, DateTime? time, String? comment) {
    var editSpend =
        _spends.firstWhereOrNull((element) => element.id == spend);
    if (editSpend == null) {
      return;
    }
    var index = _spends.lastIndexOf(editSpend);

    _spends.removeAt(index);

    _spends.insert(index, editSpend.copyWith(sum: sum, categoryId: categoryId, time: time, comment: comment));
  }
}
