import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/budget.dart';
import 'models/budget_repeat_type.dart';
import 'models/category_budget_info.dart';

class LocalBudgetRepository {
  CollectionReference get collection => FirebaseFirestore.instance
      .collection("users/${FirebaseAuth.instance.currentUser!.uid}/budgets");

  CollectionReference<Budget> get _ref => collection
      .withConverter<Budget>(
        fromFirestore: (snapshot, _) =>
            Budget.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
        toFirestore: (budget, _) => budget.toJson(),
      );

  Stream<List<Budget>> get budgets =>
      _ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  Future<void> removeAll() async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  void createTotalBudget(
    BudgetRepeatType repeatType,
    String name,
    double totalSum, {
    DateTime? startDate,
        DateTime? endDate,
    List<String>? wallets,
  }) {
    _saveBudget(TotalBudget(name, repeatType,
        startDate ?? DateTime.now(), endDate, totalSum, wallets ?? []));
  }

  void createCategoryBudget(
    BudgetRepeatType repeatType,
    String name,
    double maxSum,
    String categoryId, {
    DateTime? startDate,
        DateTime? endDate,
    List<String>? wallets,
  }) {
    _saveBudget(CategoryBudget(
      name,
      repeatType,
      startDate ?? DateTime.now(),
      endDate,
      CategoryBudgetInfo(
          categoryId: categoryId,
          maxSum: maxSum,
          wallets: wallets ?? []
      ),
    ));
  }

  void createMultiCategoryBudget(
    BudgetRepeatType repeatType,
    String name,
    List<CategoryBudgetInfo> categories, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    _saveBudget(MultiCategoryBudget(
      name,
      repeatType,
      startDate ?? DateTime.now(),
      endDate,
      categories,
    ));
  }

  void _saveBudget(Budget budget) {
    _ref.add(budget);
  }
}
