import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/budget.dart';
import 'models/budget_repeat_type.dart';
import 'models/category_budget_info.dart';

class LocalBudgetRepository {

  CollectionReference<Budget> get _ref =>
      FirebaseFirestore.instance.collection("users/${FirebaseAuth.instance.currentUser!.uid}/budgets").withConverter<Budget>(
        fromFirestore: (snapshot, _) =>
            Budget.fromJson(MapEntry(snapshot.id, snapshot.data()!)),
        toFirestore: (budget, _) => budget.toJson(),
      );

  Stream<List<Budget>> get budgets =>
      _ref.snapshots().map((event) => event.docs.map((e) => e.data()).toList());

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
      createCategoryInfo(categoryId, maxSum, wallets: wallets),
    ));
  }

  void createTotalBudgetWithCategories(
    BudgetRepeatType repeatType,
    String name,
    List<CategoryBudgetInfo> categories, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    _saveBudget(TotalBudgetWithCategories(
      name,
      repeatType,
      startDate ?? DateTime.now(),
      endDate,
      categories,
    ));
  }

  CategoryBudgetInfo createCategoryInfo(String categoryId, double maxSum,
      {List<String>? wallets}) {
    return CategoryBudgetInfo(
        categoryId: categoryId, maxSum: maxSum, wallets: wallets ?? []);
  }

  void _saveBudget(Budget budget) {
    _ref.add(budget);
  }
}
