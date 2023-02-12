import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import '../../../common/data/models/transaction_type.dart';
import 'models/category.dart';

class LocalCategoryRepository {
  DatabaseReference get _ref => FirebaseDatabase.instance.ref("users/${FirebaseAuth.instance.currentUser?.uid ?? '0'}/categories");

  Stream<List<Category>> get categories => _ref.onValue.map((event) {
    if (event.snapshot.exists) {
      Map<String, dynamic> dataValue = jsonDecode(jsonEncode(event.snapshot.value));
      return dataValue.entries.map((e) => Category.fromJson(e)).toList();
    } else {
      return <Category>[];
    }
  });

  LocalCategoryRepository() {
    //TODO Add init default categories
    // create("Car", TransactionType.spend, null);
    // create("Tax", TransactionType.spend, null);
    // create("Salary", TransactionType.income, null);
  }

  void create(String title, TransactionType transactionType, IconData? icon) async {
    var newCategory = _ref.push();
    newCategory.set(
        Category(
          title: title,
          transactionType: transactionType,
          // icon: icon,
        ).toJson()
    );
  }

  Category? getCategoryById(String id) {
    return null;
    // return categories.firstWhereOrNull((element) => element.id == id);
  }

  void remove(String category) {
    // categories.removeWhere((element) => element.id == category);
  }

  void edit(String category, String? title, TransactionType? transactionType, IconData? icon) {
    // var editCategory = categories.firstWhereOrNull((element) => element.id == category);
    // if (editCategory == null) {
    //   return;
    // }
    // var index = categories.lastIndexOf(editCategory);
    //
    // categories.removeAt(index);
    //
    // categories.insert(index, editCategory.copyWith(title, transactionType, icon, rootCategory));
  }
}
