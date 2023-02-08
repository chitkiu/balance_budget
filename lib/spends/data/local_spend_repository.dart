import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../categories/data/local_category_repository.dart';
import '../../categories/data/models/category_id.dart';
import 'models/spend.dart';
import 'models/spend_id.dart';

class LocalSpendRepository {
  final _uuid = const Uuid();
  final RxList<Spend> spends = <Spend>[].obs;

  //TODO Remove after add normal storage
  LocalSpendRepository() {
    LocalCategoryRepository category = Get.find();
    var allCategories = category.categories;
    create(
        1.1,
        allCategories[0].id,
        DateTime.now(),
        null
    );
    create(
        2.2,
        allCategories[1].id,
        DateTime.now(),
        null
    );
  }

  void create(double sum, CategoryId categoryId, DateTime time, String? comment) {
    spends.add(Spend(
      id: SpendId(_uuid.v4()),
      sum: sum,
      categoryId: categoryId,
      time: time,
      comment: comment,
    ));
  }

  void remove(SpendId spend) {
    spends.removeWhere((element) => element.id == spend);
  }

  void edit(SpendId spend, double? sum, CategoryId? categoryId, DateTime? time, String? comment) {
    var editSpend =
        spends.firstWhereOrNull((element) => element.id == spend);
    if (editSpend == null) {
      return;
    }
    var index = spends.lastIndexOf(editSpend);

    spends.removeAt(index);

    spends.insert(index, editSpend.copyWith(sum: sum, categoryId: categoryId, time: time, comment: comment));
  }
}
