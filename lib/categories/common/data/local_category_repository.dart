import 'package:balance_budget/categories/common/data/models/category_id.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'models/category.dart';

class LocalCategoryRepository {

  final _uuid = const Uuid();
  final RxList<Category> categories = <Category>[].obs;

  //TODO Remove after add normal storage
  LocalCategoryRepository() {
    create("Car", null);
    create("Tax", null);
  }

  void create(String title, IconData? icon) {
    categories.add(Category(
      id: CategoryId(_uuid.v4()),
      title: title,
      icon: icon,
    ));
  }

  Category? getCategoryById(CategoryId id) {
    return categories.firstWhereOrNull((element) => element.id == id);
  }

  void remove(CategoryId category) {
    categories.removeWhere((element) => element.id == category);
  }

  void edit(CategoryId category, String? title, IconData? icon,
      CategoryId? rootCategory) {
    var editCategory = categories.firstWhereOrNull((element) => element.id == category);
    if (editCategory == null) {
      return;
    }
    var index = categories.lastIndexOf(editCategory);

    categories.removeAt(index);

    categories.insert(index, editCategory.copyWith(title, icon, rootCategory));
  }
}
