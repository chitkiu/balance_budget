import 'dart:math';

import 'package:intl/intl.dart';

import '../../../common/data/models/wallet.dart';
import '../../ui/models/wallet_ui_model.dart';

final NumberFormat _sumFormatter = NumberFormat("##0.00");

class WalletUIMapper {
  const WalletUIMapper();

  WalletUIModel map(Wallet wallet, double balance) {
    if (wallet is CreditWallet) {
      double spendedCreditSum = 0;
      if (balance < 0) {
        spendedCreditSum = balance * -1;
      }
      return CreditWalletUIModel(
        totalCreditSum: _sumFormatter.format(wallet.creditBalance),
        spendedCreditSum: _sumFormatter.format(spendedCreditSum),
        ownSum: _sumFormatter.format(max(0, balance)),
        id: wallet.id,
        name: wallet.name,
        balance: _sumFormatter.format(wallet.creditBalance + balance),
        isArchived: wallet.archived,
      );
    }
    return DefaultWalletUIModel(
      id: wallet.id,
      name: wallet.name,
      balance: _sumFormatter.format(balance),
      isArchived: wallet.archived,
    );
  }
}
