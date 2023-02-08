import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../categories/data/local_category_repository.dart';
import 'local_spend_repository.dart';
import 'models/rich_spend_model.dart';

class SpendAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();
  LocalSpendRepository get _spendRepository => Get.find();

  Stream<List<RichSpendModel>> spends() {
    return CombineLatestStream.combine2(
      _categoryRepository.categories.stream,
      _spendRepository.spends.stream,
      (categories, spends) {
        return spends
            .map((e) {
              var category = categories
                  .firstWhereOrNull((element) => element.id == e.categoryId);
              if (category == null) {
                return null;
              }
              return RichSpendModel(e, category);
            })
            .whereType<RichSpendModel>()
            .toList();
      },
    );
  }
}
