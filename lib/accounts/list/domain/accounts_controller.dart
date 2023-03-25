import 'dart:async';

import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../../transactions/common/data/models/transaction.dart';
import '../../add/domain/add_account_binding.dart';
import '../../add/ui/add_account_screen.dart';
import '../../common/data/local_account_repository.dart';
import '../../common/data/models/account.dart';
import '../ui/models/account_ui_model.dart';
import 'mappers/account_ui_mapper.dart';

class AccountsController extends GetxController {
  LocalAccountRepository get _accountRepo => Get.find();
  LocalTransactionsRepository get _transactionRepo => Get.find();

  final AccountUIMapper _mapper = AccountUIMapper();

  RxList<AccountUIModel> accounts = <AccountUIModel>[].obs;
  StreamSubscription? _listener;

  @override
  void onReady() {
    _listener?.cancel();
    _listener = CombineLatestStream.combine2(
        _transactionRepo.transactions,
        _accountRepo.accounts,
        (a, b) {
          return MapEntry(a, b);
        }
    )
    .listen((value) {
      var transactionsData = value.key;
      var accountsData = value.value;
      accounts.value = accountsData.map((e) {
        return _mapper.map(e, _calculateTransactions(transactionsData, e));
      }).toList();
    });

    super.onReady();
  }

  @override
  void onClose() {
    _listener?.cancel();
    _listener = null;
    super.onClose();
  }

  void onAddClick() {
    Get.to(
          () => AddAccountScreen(),
      binding: AddAccountBinding(),
    );
  }

  double _calculateTransactions(List<Transaction> transactions, Account account) {
    var filteredTransaction = transactions.where((element) =>
    element.accountId == account.id);

    var totalSum = 0.0;
    for (var transaction in filteredTransaction) {
      switch (transaction.transactionType) {
        case TransactionType.setInitialBalance:
          totalSum += transaction.sum;
          break;
        case TransactionType.spend:
          totalSum -= transaction.sum;
          break;
        case TransactionType.income:
          totalSum += transaction.sum;
          break;
        case TransactionType.transfer:
          // Do nothing - will be added in next loop
          break;
      }
    }

    totalSum += _getTransferTotalSum(transactions, account);

    return totalSum;
  }

  double _getTransferTotalSum(List<Transaction> transactions, Account account) {
    var filteredTransferTransaction = transactions.where((element) =>
    element is TransferTransaction &&
        (element.accountId == account.id || element.toAccountId == account.id)
    )
        .map((e) => e as TransferTransaction);

    var totalSum = 0.0;

    for (var transaction in filteredTransferTransaction) {
      if (transaction.accountId == account.id) {
        totalSum -= transaction.sum;
      } else if (transaction.toAccountId == account.id) {
        totalSum += transaction.sum;
      }
    }

    return totalSum;
  }
}