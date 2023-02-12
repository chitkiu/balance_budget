import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'models/budget.dart';
import 'models/budget_date.dart';
import 'models/budget_repeat_type.dart';
import 'models/category_budget_info.dart';

class LocalBudgetRepository {

  DatabaseReference get _ref => FirebaseDatabase.instance.ref("users/${FirebaseAuth.instance.currentUser?.uid ?? '0'}/budgets");
  // RxList<Budget> budgets = <Budget>[].obs;
  Stream<List<Budget>> get budgets => _ref.onValue.map((event) {
    if (event.snapshot.exists) {
      Map<String, dynamic> dataValue = jsonDecode(jsonEncode(event.snapshot.value));
      return dataValue.entries.map((e) => Budget.fromJson(e)).toList();
    } else {
      return <Budget>[];
    }
  });


  //TODO Remove after add normal storage
  LocalBudgetRepository() {
/*
    LocalCategoryRepository category = Get.find();
    var categories =
        category.categories.where((p0) => p0.transactionType == TransactionType.spend).toList();

    createCategoryBudget(
      BudgetRepeatType.oneTime,
      BudgetRepeatType.oneTime.name,
      1000,
      categories.first.id,
      startDate: const BudgetDate(year: 2023, month: 2, day: 8),
    );

    createTotalBudgetWithCategories(
      BudgetRepeatType.oneTime,
      BudgetRepeatType.oneTime.name,
      [
        createCategoryInfo(categories.first.id, 500),
        createCategoryInfo(categories[1].id, 1000),
      ],
      // startDate: const BudgetDate(year: 2023, month: 2, day: 8),
    );*/
  }

  void createTotalBudget(
    BudgetRepeatType repeatType,
    String name,
    double totalSum, {
    BudgetDate? startDate,
    BudgetDate? endDate,
    List<String>? accounts,
  }) {
    _saveBudget(TotalBudget(name, repeatType,
        startDate ?? BudgetDate.fromNow(), endDate, totalSum, accounts ?? []));
  }

  void createCategoryBudget(
    BudgetRepeatType repeatType,
    String name,
    double maxSum,
    String categoryId, {
    BudgetDate? startDate,
    BudgetDate? endDate,
    List<String>? accounts,
  }) {
    _saveBudget(CategoryBudget(
      name,
      repeatType,
      startDate ?? BudgetDate.fromNow(),
      endDate,
      createCategoryInfo(categoryId, maxSum, accounts: accounts),
    ));
  }

  void createTotalBudgetWithCategories(
    BudgetRepeatType repeatType,
    String name,
    List<CategoryBudgetInfo> categories, {
    BudgetDate? startDate,
    BudgetDate? endDate,
  }) {
    _saveBudget(TotalBudgetWithCategories(
      name,
      repeatType,
      startDate ?? BudgetDate.fromNow(),
      endDate,
      categories,
    ));
  }

  CategoryBudgetInfo createCategoryInfo(String categoryId, double maxSum,
      {List<String>? accounts}) {
    return CategoryBudgetInfo(
        categoryId: categoryId, maxSum: maxSum, accounts: accounts ?? []);
  }

  void _saveBudget(Budget budget) {
    var newBudget = _ref.push();
    newBudget.set(
        budget.toJson()
    );
  }
}
