import 'package:balance_budget/categories/common/data/models/category_id.dart';
import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'models/category.dart';

class LocalCategoryRepository {
  Uuid get _uuid => Get.find();

  final RxList<Category> categories = <Category>[].obs;

  //TODO Remove after add normal storage
  LocalCategoryRepository() {
    create("Car", TransactionType.spend, null);
    create("Tax", TransactionType.spend, null);
    create("Salary", TransactionType.income, null);
  }

  void create(String title, TransactionType transactionType, IconData? icon) {
    categories.add(Category(
      id: CategoryId(_uuid.v4()),
      title: title,
      transactionType: transactionType,
      icon: icon,
    ));
  }

  Category? getCategoryById(CategoryId id) {
    return categories.firstWhereOrNull((element) => element.id == id);
  }

  void remove(CategoryId category) {
    categories.removeWhere((element) => element.id == category);
  }

  void edit(CategoryId category, String? title, TransactionType? transactionType, IconData? icon,
      CategoryId? rootCategory) {
    var editCategory = categories.firstWhereOrNull((element) => element.id == category);
    if (editCategory == null) {
      return;
    }
    var index = categories.lastIndexOf(editCategory);

    categories.removeAt(index);

    categories.insert(index, editCategory.copyWith(title, transactionType, icon, rootCategory));
  }
}
