import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../categories/common/data/local_category_repository.dart';
import '../../common/data/models/transaction_type.dart';
import '../../transactions/common/data/local_transactions_repository.dart';
import '../../wallets/common/data/local_wallet_repository.dart';
import 'models/column_types.dart';

class ImportController extends GetxController {
  final List<String> columnNames;
  final List<List<String>> transactions;

  final RxMap<int, ColumnTypes> items = RxMap();

  LocalCategoryRepository get _categoryRepo => Get.find();
  LocalWalletRepository get _walletRepo => Get.find();
  LocalTransactionsRepository get _transactionsRepo => Get.find();

  ImportController({required this.columnNames, required this.transactions});

  Iterable<String>? getAllCategories() {
    int categoryIndex = items.keys.firstWhere(
            (k) => items[k] == ColumnTypes.category, orElse: () => -1);
    if (categoryIndex < 0) {
      return null;
    } else {
      return transactions.map((row) => row[categoryIndex]).toSet();
    }
  }

  Future<void> parseData(String transferCategoryName) async {
    int dateIndex = items.keys.firstWhere(
            (k) => items[k] == ColumnTypes.date, orElse: () => -1);
    if (dateIndex < 0) {
      return;
    }
    int walletIndex = items.keys.firstWhere(
            (k) => items[k] == ColumnTypes.wallet, orElse: () => -1);
    if (walletIndex < 0) {
      return;
    }
    int categoryIndex = items.keys.firstWhere(
            (k) => items[k] == ColumnTypes.category, orElse: () => -1);
    if (categoryIndex < 0) {
      return;
    }
    int commentIndex = items.keys.firstWhere(
            (k) => items[k] == ColumnTypes.comment, orElse: () => -1);

    int incomeSumIndex = items.keys.firstWhere(
            (k) => items[k] == ColumnTypes.incomeSum, orElse: () => -1);
    int expenseSumIndex = items.keys.firstWhere(
            (k) => items[k] == ColumnTypes.expenseSum, orElse: () => -1);
    int sumIndex = items.keys.firstWhere(
            (k) => items[k] == ColumnTypes.sum, orElse: () => -1);

    final Iterable<List<String>> filteredTransactions;
    if (transferCategoryName.isEmpty) {
      filteredTransactions = transactions;
    } else {
      filteredTransactions = transactions.where((element) {
        return element[categoryIndex] != transferCategoryName;
      });
    }

    for (var transaction in filteredTransactions) {
      debugPrint("transaction: $transaction");
      final dateStr = transaction[dateIndex].clean;
      DateTime? parsedDate = _parseDate(dateStr);

      if (parsedDate == null) {
        continue;
      }

      if (sumIndex >= 0 || (incomeSumIndex >= 0 && expenseSumIndex >= 0)) {
        final walletName = transaction[walletIndex];
        debugPrint("Wallet name: $walletName");
        var wallet = await _walletRepo.getWalletByName(walletName);
        wallet ??= await _walletRepo.createDebit(walletName, 0.0);

        TransactionType? transactionType;
        double? finalSum;
        if (sumIndex >= 0) {
          double? sum = double.tryParse(transaction[sumIndex].cleanNumber);
          if (sum != null) {
            finalSum = sum;
            if (sum > 0) {
              transactionType = TransactionType.income;
            } else if (sum < 0) {
              transactionType = TransactionType.expense;
            }
          }
        }
        debugPrint("transactionType: $transactionType");

        if (incomeSumIndex >= 0 && expenseSumIndex >= 0 &&
            transactionType == null) {
          double? incomeSum = double.tryParse(
              transaction[incomeSumIndex].cleanNumber);
          if (incomeSum != null && incomeSum > 0) {
            finalSum = incomeSum;
            transactionType = TransactionType.income;
          } else {
            double? expenseSum = double.tryParse(
                transaction[expenseSumIndex].cleanNumber);
            if (expenseSum != null && expenseSum > 0) {
              finalSum = expenseSum;
              transactionType = TransactionType.expense;
            }
          }
        }
        debugPrint("transactionType: $transactionType");

        if (finalSum == null) {
          continue;
        }

        final categoryName = transaction[categoryIndex];
        var category = await _categoryRepo.getCategoryByName(categoryName);

        if (transactionType == null) {
          if (category != null) {
            transactionType = category.transactionType;
          } else {
            continue;
          }
        }

        category ??=
            await _categoryRepo.create(categoryName, transactionType, null);

        final comment = commentIndex != -1 ? transaction[commentIndex] : null;

        _transactionsRepo.createOrUpdate(
            finalSum,
            transactionType,
            wallet.id,
            parsedDate,
            categoryId: category.id,
            comment: comment?.isEmpty == true ? null : comment
        );
      } else {
        continue;
      }
    }

    final transferTransactions = transactions.where((element) {
      return element[categoryIndex] == transferCategoryName;
    });

    for (var value in transferTransactions) {

    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      debugPrint("Cannot parse on default way, try other...");
      e.printError();
      try {
        final date = dateStr.split(".");
        return DateTime(int.parse(date[2]), int.parse(date[1]), int.parse(date[0]));
      } catch (e) {
        e.printError();
        return null;
      }
    }
  }

}

extension _ClearStringForParce on String {
  String get cleanNumber => clean.replaceAll(RegExp(r',+'), ".");
  String get clean => replaceAll(RegExp(r'\ +'), "").replaceAll(RegExp(r' +'), "");
}
