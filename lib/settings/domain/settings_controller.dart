import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../categories/list/domain/categories_binding.dart';
import '../../categories/list/ui/categories_screen.dart';
import '../../import/domain/import_binding.dart';
import '../../import/ui/import_screen.dart';

class SettingsController extends GetxController {

  void onManageCategoriesClick() {
    Get.to(
          () => CategoriesScreen(),
      binding: CategoriesBinding(),
    );
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