import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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
      archived: false,
    ),
    Category(
      title: Get.localisation.transferCategoryTitle,
      transactionType: TransactionType.transfer,
      //TODO Change icon
      icon: Icons.compare_arrows,
      archived: false,
    ),
  ];

  CollectionReference<Category> get _ref => FirebaseFirestore.instance
      .collection("users/${FirebaseAuth.instance.currentUser!.uid}/categories")
      .withConverter<Category>(
        fromFirestore: (snapshot, _) =>
            Category.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
        toFirestore: (category, _) => category.toJson(),
      );

  Stream<List<Category>> get categories => _ref.snapshots().map((event) {
        var result = event.docs.map((e) => e.data()).toList();
        result.addAll(_localCategories);
        return result;
      });

  Stream<List<Category>> get categoriesWithoutArchived =>
      _ref.where("archived", isEqualTo: false).snapshots().map((event) {
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
    _ref.add(Category(
      title: title,
      transactionType: transactionType,
      icon: icon ?? Icons.not_interested,
      archived: false,
    ));
  }

  Stream<Category?> categoryById(String id) {
    return _ref.doc(id).snapshots().map((event) => event.data());
  }

  Future<Category?> getCategoryById(String id) async {
    return (await _ref.doc(id).get()).data();
  }

  Stream<List<Category>> getCategoriesByType(TransactionType type) {
    return _ref
        .where('transactionType', isEqualTo: type.name)
        .snapshots()
        .map((categories) => categories.docs
            .map((category) {
              if (category.exists) {
                return category.data();
              } else {
                return null;
              }
            })
            .whereNotNull()
            .toList());
  }

  void remove(String category) {
    // categories.removeWhere((element) => element.id == category);
  }

  Future<void> edit(
      String id, {String? title, TransactionType? transactionType, IconData? icon, bool? archived}) async {
    final data = _ref.doc(id);

    final editCategory = (await data.get()).data();

    if (editCategory == null) {
      return;
    }

    Category newCategory = editCategory.copyWith(
        title: title, transactionType: transactionType, icon: icon, archived: archived);

    await data.set(newCategory);
  }
}
