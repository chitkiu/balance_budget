import 'dart:async';

import 'package:balance_budget/common/data/models/transaction_type.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/pair.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../../transactions/common/data/models/transaction.dart';
import '../../add/domain/add_wallet_binding.dart';
import '../../add/ui/add_wallet_screen.dart';
import '../../common/data/local_wallet_repository.dart';
import '../../common/data/models/wallet.dart';
import '../ui/models/wallet_ui_model.dart';
import 'mappers/wallet_ui_mapper.dart';

class WalletsController extends GetxController {
  LocalWalletRepository get _walletRepo => Get.find();
  LocalTransactionsRepository get _transactionRepo => Get.find();

  final WalletUIMapper _mapper = WalletUIMapper();

  Stream<List<WalletUIModel>> getWallets() {
    return CombineLatestStream.combine2(
        _transactionRepo.transactions,
        _walletRepo.wallets,
            (a, b) {
          return Pair(a, b);
        }
    )
    .map((value) {
      var transactionsData = value.first;
      var walletsData = value.second;
      return walletsData.map((e) {
        return _mapper.map(e, _calculateTransactions(transactionsData, e));
      }).toList();
    });
  }

  void onAddClick() {
    Get.to(
          () => AddWalletScreen(),
      binding: AddWalletBinding(),
    );
  }

  double _calculateTransactions(List<Transaction> transactions, Wallet wallet) {
    var filteredTransaction = transactions.where((element) =>
    element.walletId == wallet.id);

    var totalSum = 0.0;
    for (var transaction in filteredTransaction) {
      switch (transaction.transactionType) {
        case TransactionType.setInitialBalance:
          totalSum += transaction.sum;
          break;
        case TransactionType.expense:
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

    totalSum += _getTransferTotalSum(transactions, wallet);

    return totalSum;
  }

  double _getTransferTotalSum(List<Transaction> transactions, Wallet wallet) {
    var filteredTransferTransaction = transactions.where((element) =>
    element is TransferTransaction &&
        (element.walletId == wallet.id || element.toWalletId == wallet.id)
    )
        .map((e) => e as TransferTransaction);

    var totalSum = 0.0;

    for (var transaction in filteredTransferTransaction) {
      if (transaction.walletId == wallet.id) {
        totalSum -= transaction.sum;
      } else if (transaction.toWalletId == wallet.id) {
        totalSum += transaction.sum;
      }
    }

    return totalSum;
  }
}