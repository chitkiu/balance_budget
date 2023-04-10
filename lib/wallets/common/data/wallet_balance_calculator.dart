import 'package:balance_budget/transactions/common/data/models/rich_transaction_model.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../transactions/common/data/models/transaction.dart';
import 'models/wallet.dart';

class WalletBalanceCalculator {
  const WalletBalanceCalculator();

  double calculateBalanceFromRich(
      List<RichTransactionModel> transactions, Wallet wallet) {
    return calculateBalance(transactions.map((e) => e.transaction), wallet);
  }

  double calculateBalance(Iterable<Transaction> transactions, Wallet wallet) {
    var filteredTransaction =
        transactions.where((element) => element.walletId == wallet.id);

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

  double _getTransferTotalSum(
      Iterable<Transaction> transactions, Wallet wallet) {
    var filteredTransferTransaction = transactions
        .where((element) =>
            element is TransferTransaction &&
            (element.walletId == wallet.id || element.toWalletId == wallet.id))
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
