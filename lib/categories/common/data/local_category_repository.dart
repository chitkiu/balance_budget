import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import 'models/category.dart';

//TODO Add translation
class LocalCategoryRepository {
  final List<Category> _localCategories = [
    Category(
      name: /*Get.localisation.*/"addInitialBalanceCategoryTitle",
      transactionType: TransactionType.setInitialBalance,
      archived: false,
    ),
    Category(
      name: /*Get.localisation.*/"transferCategoryTitle",
      transactionType: TransactionType.transfer,
      //TODO Change icon
      icon: Icons.compare_arrows,
      archived: false,
    ),
  ];

  CollectionReference get collection => FirebaseFirestore.instance
      .collection("users/${FirebaseAuth.instance.currentUser!.uid}/categories");

  CollectionReference<Category> get _ref => collection
      .withConverter<Category>(
        fromFirestore: (snapshot, _) =>
            Category.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
        toFirestore: (category, _) => category.toJson(),
      );

  LocalTransactionsRepository get _transactionRepo => Get.find();

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

  Future<void> removeAll() async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<Category> create(String title, TransactionType transactionType, IconData? icon) async {
    final newCategory = await _ref.add(Category(
      name: title,
      transactionType: transactionType,
      icon: icon ?? Icons.not_interested,
      archived: false,
    ));

    return (await newCategory.get()).data()!;
  }

  Stream<Category?> categoryById(String id) {
    return _ref.doc(id).snapshots().map((event) => event.data());
  }

  Future<Category?> getCategoryById(String id) async {
    return (await _ref.doc(id).get()).data();
  }

  Future<Category?> getCategoryByName(String name) async {
    final categories = await _ref.where('name', isEqualTo: name).get();
    return categories.docs.map((event) {
      if (event.exists) {
        return event.data();
      } else {
        return null;
      }
    })
        .whereNotNull()
        .firstOrNull;
  }

  Stream<List<Category>> getCategoriesByType(TransactionType type) {
    return _ref
        .where('transactionType', isEqualTo: type.name)
        .where("archived", isEqualTo: false)
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

  Future<void> delete(String categoryId) async {
    await _ref.doc(categoryId).delete();
    final transactions = await _transactionRepo.getTransactionsByCategoryId(categoryId);
    await _transactionRepo.bunchDelete(transactions.map((e) => e.id).toList());
    //TODO Add budget removing
  }

  Future<void> edit(
      String id, {String? title, TransactionType? transactionType, IconData? icon, bool? archived}) async {
    final data = _ref.doc(id);

    final editCategory = (await data.get()).data();

    if (editCategory == null) {
      return;
    }

    Category newCategory = editCategory.copyWith(
        name: title, transactionType: transactionType, icon: icon, archived: archived);

    await data.set(newCategory);
  }
}
