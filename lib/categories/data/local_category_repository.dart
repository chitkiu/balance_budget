import 'package:balance_budget/categories/data/models/category_id.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'models/category.dart';

class LocalCategoryRepository {

  final _uuid = const Uuid();
  final List<Category> _categories = [];

  void create(String title, IconData? icon, CategoryId? rootCategory) {
    _categories.add(Category(
      id: CategoryId(_uuid.v4()),
      title: title,
      icon: icon,
      rootCategory: rootCategory,
    ));
  }

  List<Category> getAllCategories() {
    return _categories;
  }

  void remove(CategoryId category) {
    _categories.removeWhere((element) => element.id == category);
  }

  void edit(CategoryId category, String? title, IconData? icon,
      CategoryId? rootCategory) {
    var editCategory = _categories.firstWhereOrNull((element) => element.id == category);
    if (editCategory == null) {
      return;
    }
    var index = _categories.lastIndexOf(editCategory);

    _categories.removeAt(index);

    _categories.insert(index, editCategory.copyWith(title, icon, rootCategory));
  }
}
