import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../budgets/common/data/local_budget_repository.dart';
import '../../categories/common/data/local_category_repository.dart';
import '../../categories/list/domain/categories_binding.dart';
import '../../categories/list/ui/categories_screen.dart';
import '../../import/domain/import_binding.dart';
import '../../import/ui/import_screen.dart';
import '../../transactions/common/data/local_transactions_repository.dart';
import '../../wallets/common/data/local_wallet_repository.dart';

class SettingsController extends GetxController {

  LocalTransactionsRepository get _transactionRepo => Get.find();
  LocalBudgetRepository get _budgetRepo => Get.find();
  LocalCategoryRepository get _categoryRepo => Get.find();
  LocalWalletRepository get _walletRepo => Get.find();

  void onManageCategoriesClick() {
    Get.to(
          () => CategoriesScreen(),
      binding: CategoriesBinding(),
    );
  }

  Future<void> removeAllData() async {
    await _transactionRepo.removeAll();
    await _budgetRepo.removeAll();
    await _categoryRepo.removeAll();
    await _walletRepo.removeAll();
  }

  Future<void> parseData(String path) async {
    File file = File(path);
    final text = await file.readAsString();
    final csv = const CsvToListConverter().convert<String>(text, eol: "\n", shouldParseNumbers: false);
    final columnTitles = csv.sublist(0, 1).single;
    final transactions = csv.sublist(1);
    debugPrint("${columnTitles}");
    debugPrint("${transactions}");
    Get.to(
        () => const ImportScreen(),
      binding: ImportBinding(columnNames: columnTitles, transactions: transactions),
    );
  }

}