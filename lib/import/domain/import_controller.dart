import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rxdart/transformers.dart';

import '../../categories/common/data/local_category_repository.dart';
import '../../categories/common/data/models/category.dart' as domain_category;
import '../../common/data/models/transaction_type.dart';
import '../../common/pair.dart';
import '../../transactions/common/data/local_transactions_repository.dart';
import '../../wallets/common/data/local_wallet_repository.dart';
import '../../wallets/common/data/models/wallet.dart';
import 'models/column_types.dart';

class ImportController extends GetxController {
  final List<String> columnNames;
  final List<List<String>> transactions;

  final RxMap<int, ColumnTypes> items = RxMap();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalWalletRepository get _walletRepo => Get.find();

  LocalTransactionsRepository get _transactionsRepo => Get.find();

  ImportController({required this.columnNames, required this.transactions});


  @override
  void onReady() {
    super.onReady();

    for (var i = 0; i < columnNames.length; i++) {
      final name = columnNames[i].toLowerCase();

      if (name.contains("expense")) {
        items[i] = ColumnTypes.expenseSum;
      } else if (name.contains("расход")) {
        items[i] = ColumnTypes.expenseSum;
      } else if (name.contains("витрата")) {
        items[i] = ColumnTypes.expenseSum;
      } else if (name.contains("income")) {
        items[i] = ColumnTypes.incomeSum;
      } else if (name.contains("доход")) {
        items[i] = ColumnTypes.incomeSum;
      } else if (name.contains("дохід")) {
        items[i] = ColumnTypes.incomeSum;
      } else if (name.contains("date")) {
        items[i] = ColumnTypes.date;
      } else if (name.contains("дата")) {
        items[i] = ColumnTypes.date;
      } else if (name.contains("wallet")) {
        items[i] = ColumnTypes.wallet;
      } else if (name.contains("кошелек")) {
        items[i] = ColumnTypes.wallet;
      } else if (name.contains("кошелёк")) {
        items[i] = ColumnTypes.wallet;
      } else if (name.contains("счет")) {
        items[i] = ColumnTypes.wallet;
      } else if (name.contains("счёт")) {
        items[i] = ColumnTypes.wallet;
      } else if (name.contains("гаманець")) {
        items[i] = ColumnTypes.wallet;
      } else if (name.contains("рахунок")) {
        items[i] = ColumnTypes.wallet;
      } else if (name.contains("category")) {
        items[i] = ColumnTypes.category;
      } else if (name.contains("категория")) {
        items[i] = ColumnTypes.category;
      } else if (name.contains("категорія")) {
        items[i] = ColumnTypes.category;
      } else if (name.contains("description")) {
        items[i] = ColumnTypes.comment;
      } else if (name.contains("comment")) {
        items[i] = ColumnTypes.comment;
      } else if (name.contains("описание")) {
        items[i] = ColumnTypes.comment;
      } else if (name.contains("опис")) {
        items[i] = ColumnTypes.comment;
      } else if (name.contains("комментарий")) {
        items[i] = ColumnTypes.comment;
      } else if (name.contains("коментар")) {
        items[i] = ColumnTypes.comment;
      }
    }
  }

  Iterable<String>? getAllCategories() {
    int categoryIndex = items.keys.firstWhere((k) => items[k] == ColumnTypes.category,
        orElse: () => -1);
    if (categoryIndex < 0) {
      return null;
    } else {
      return transactions.map((row) => row[categoryIndex]).toSet();
    }
  }

  Future<void> parseData(String transferCategoryName) async {
    int dateIndex = items.keys.firstWhere((k) => items[k] == ColumnTypes.date,
        orElse: () => -1);
    if (dateIndex < 0) {
      return;
    }
    int walletIndex = items.keys.firstWhere((k) => items[k] == ColumnTypes.wallet,
        orElse: () => -1);
    if (walletIndex < 0) {
      return;
    }
    int categoryIndex = items.keys.firstWhere((k) => items[k] == ColumnTypes.category,
        orElse: () => -1);
    if (categoryIndex < 0) {
      return;
    }
    int commentIndex = items.keys.firstWhere((k) => items[k] == ColumnTypes.comment,
        orElse: () => -1);

    int incomeSumIndex = items.keys.firstWhere((k) => items[k] == ColumnTypes.incomeSum,
        orElse: () => -1);
    int expenseSumIndex = items.keys.firstWhere((k) => items[k] == ColumnTypes.expenseSum,
        orElse: () => -1);
    int sumIndex = items.keys.firstWhere((k) => items[k] == ColumnTypes.sum,
        orElse: () => -1);

    final Iterable<List<String>> filteredTransactions;
    if (transferCategoryName.isEmpty) {
      filteredTransactions = transactions;
    } else {
      filteredTransactions = transactions.where((element) {
        return element[categoryIndex] != transferCategoryName;
      });
    }

    for (var transaction in filteredTransactions) {
      final result = await _parseData(transaction, dateIndex: dateIndex,
          walletIndex: walletIndex,
          categoryIndex: categoryIndex,
          commentIndex: commentIndex,
          incomeSumIndex: incomeSumIndex,
          expenseSumIndex: expenseSumIndex,
          sumIndex: sumIndex);

      if (result != null) {
        String walletId;
        if (result.wallet.id.isEmpty) {
          walletId = (await _walletRepo.createDebit(result.wallet.name, 0.0)).id;
        } else {
          walletId = result.wallet.id;
        }

        String categoryId;
        if (result.category.id.isEmpty) {
          categoryId = (await _categoryRepo.create(
              result.category.name, result.category.transactionType, null)).id;
        } else {
          categoryId = result.category.id;
        }

        _transactionsRepo.createOrUpdate(
          result.sum,
          result.transactionType,
          walletId,
          result.date,
          categoryId: categoryId,
          comment: result.comment,
        );
      }
    }

    if (transferCategoryName.isNotEmpty) {
      List<_ParsedData> transferTransactions = await Stream.fromIterable(
          transactions.where((element) {
            return element[categoryIndex] == transferCategoryName;
          })).asyncMap((transferTransaction) async {
        final result = await _parseData(transferTransaction, dateIndex: dateIndex,
            walletIndex: walletIndex,
            categoryIndex: categoryIndex,
            commentIndex: commentIndex,
            incomeSumIndex: incomeSumIndex,
            expenseSumIndex: expenseSumIndex,
            sumIndex: sumIndex);
        if (result == null) {
          return null;
        }
        Wallet newWallet = result.wallet;
        if (newWallet.id.isEmpty) {
          newWallet = await _walletRepo.createDebit(newWallet.name, 0.0);
        }
        return result.copyWith(
          newWallet: newWallet,
        );
      }).whereNotNull().toList();

      Map<Pair<DateTime, double>, List<_ParsedData>> groupedTransfers = groupBy(
          transferTransactions, (p0) => Pair(p0.date, p0.sum));

      for (var mapEntry in groupedTransfers.entries) {
        final key = mapEntry.key;
        final value = mapEntry.value;

        if (value.isNotEmpty) {
          const maxItemPerTransaction = 2;
          if (value.length % maxItemPerTransaction == 0) {
            var transactionCount = (value.length / maxItemPerTransaction).round();
            var splittedTransaction = List.generate(transactionCount, (i) =>
                value.sublist(maxItemPerTransaction * i,
                    (i + 1) * maxItemPerTransaction <= value.length ? (i + 1) *
                        maxItemPerTransaction : null));

            for (var transferTransaction in splittedTransaction) {
              final from = transferTransaction.firstWhereOrNull((element) =>
              element.transactionType == TransactionType.expense);
              final to = transferTransaction.firstWhereOrNull((element) =>
              element.transactionType == TransactionType.income);

              if (from != null && to != null) {
                if (from.wallet.id.isNotEmpty && to.wallet.id.isNotEmpty) {
                  _transactionsRepo.createOrUpdate(
                      from.sum,
                      TransactionType.transfer,
                      from.wallet.id,
                      from.date,
                      comment: from.comment ?? to.comment,
                      toWalletId: to.wallet.id
                  );
                } else {
                  debugPrint("Something wrong with transfer transactions wallet id...");
                }
              } else {
                debugPrint("Something wrong with transfer transactions...");
              }
            }
          } else {
            debugPrint("Something wrong with grouped transfer transaction...");
          }
          debugPrint("$key, $value");
        }
      }
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

  Future<_ParsedData?> _parseData(List<String> data,
      {required int dateIndex, required int walletIndex, required int categoryIndex, required int commentIndex, required int incomeSumIndex, required int expenseSumIndex, required int sumIndex,}) async {
    debugPrint("transaction: $data");
    final dateStr = data[dateIndex].clean;
    DateTime? parsedDate = _parseDate(dateStr);

    if (parsedDate == null) {
      return null;
    }

    if (sumIndex >= 0 || (incomeSumIndex >= 0 && expenseSumIndex >= 0)) {
      final walletName = data[walletIndex];
      debugPrint("Wallet name: $walletName");
      var wallet = await _walletRepo.getWalletByName(walletName);
      wallet ??= DebitWallet(name: walletName, archived: false);

      TransactionType? transactionType;
      double? finalSum;
      if (sumIndex >= 0) {
        double? sum = double.tryParse(data[sumIndex].cleanNumber);
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

      if (incomeSumIndex >= 0 && expenseSumIndex >= 0 && transactionType == null) {
        double? incomeSum = double.tryParse(data[incomeSumIndex].cleanNumber);
        if (incomeSum != null && incomeSum > 0) {
          finalSum = incomeSum;
          transactionType = TransactionType.income;
        } else {
          double? expenseSum = double.tryParse(data[expenseSumIndex].cleanNumber);
          if (expenseSum != null && expenseSum > 0) {
            finalSum = expenseSum;
            transactionType = TransactionType.expense;
          }
        }
      }
      debugPrint("transactionType: $transactionType");

      if (finalSum == null) {
        return null;
      }

      final categoryName = data[categoryIndex];
      var category = await _categoryRepo.getCategoryByName(categoryName);

      if (transactionType == null) {
        if (category != null) {
          transactionType = category.transactionType;
        } else {
          return null;
        }
      }

      category ??= domain_category.Category(
        name: categoryName, transactionType: transactionType, archived: false,);

      final comment = commentIndex != -1 ? data[commentIndex] : null;

      return _ParsedData(parsedDate, category, wallet, transactionType, finalSum,
        comment?.isEmpty == true ? null : comment,);
    } else {
      return null;
    }
  }
}

class _ParsedData {
  final DateTime date;
  final domain_category.Category category;
  final Wallet wallet;
  final TransactionType transactionType;
  final double sum;
  final String? comment;

  _ParsedData(this.date, this.category, this.wallet, this.transactionType, this.sum,
      this.comment);

  _ParsedData copyWith({Wallet? newWallet, domain_category.Category? newCategory}) {
    return _ParsedData(
      date,
      newCategory ?? category,
      newWallet ?? wallet,
      transactionType,
      sum,
      comment,
    );
  }

  @override
  String toString() {
    return '_ParsedData{date: $date, category: $category, wallet: $wallet, transactionType: $transactionType, sum: $sum, comment: $comment}';
  }
}

extension _ClearStringForParce on String {
  String get cleanNumber => clean.replaceAll(RegExp(r',+'), ".");
  String get clean => replaceAll(RegExp(r'\ +'), "").replaceAll(RegExp(r' +'), "");
}
