import 'dart:async';

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
    var filteredTransaction = transactions.where((element) => element.accountId == account.id);
    var totalSum = 0.0;
    for (var value in filteredTransaction) {
      totalSum += value.sum;
    }

    return totalSum;
  }
}