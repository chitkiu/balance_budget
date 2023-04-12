import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/getx_extensions.dart';
import 'models/category.dart';

class LocalCategoryRepository {
  final List<Category> _localCategories = [
    Category(
      title: Get.localisation.addInitialBalanceCategoryTitle,
      transactionType: TransactionType.setInitialBalance,
    ),
    Category(
      title: Get.localisation.transferCategoryTitle,
      transactionType: TransactionType.transfer,
      //TODO Change icon
      icon: Icons.compare_arrows,
    ),
  ];

  CollectionReference<Category> get _ref =>
      FirebaseFirestore.instance.collection("users/${FirebaseAuth.instance.currentUser!.uid}/categories").withConverter<Category>(
        fromFirestore: (snapshot, _) =>
            Category.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
        toFirestore: (category, _) => category.toJson(),
      );

  Stream<List<Category>> get categories =>
      _ref.snapshots().map((event) {
        var result = event.docs.map((e) => e.data()).toList();
        result.addAll(_localCategories);
        return result;
      });

  LocalCategoryRepository() {
    //TODO Add init default categories
    // create("Car", TransactionType.spend, null);
    // create("Tax", TransactionType.spend, null);
    // create("Salary", TransactionType.income, null);
  }

  void create(String title, TransactionType transactionType, IconData? icon) async {
    _ref.add(
        Category(
          title: title,
          transactionType: transactionType,
          icon: icon ?? Icons.not_interested,
        )
    );
  }

  Stream<Category?> getCategoryById(String id) {
    return _ref.doc(id).snapshots().map((event) => event.data());
  }

  Future<List<Category>> getCategoriesByType(TransactionType type) async {
    var result = await _ref.orderBy('transactionType')
        .where('transactionType', isEqualTo: type.name)
        .get();

    return result.docs.map((e) => e.data()).toList();
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
