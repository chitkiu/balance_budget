import 'package:intl/intl.dart';

import '../../../common/data/models/wallet.dart';
import '../../ui/models/wallet_ui_model.dart';

final NumberFormat _sumFormatter = NumberFormat("##0.00");

class WalletUIMapper {
  const WalletUIMapper();

  WalletUIModel map(Wallet wallet, double balance) {
    if (wallet is CreditWallet) {
      return CreditWalletUIModel(
        creditSum: _sumFormatter.format(wallet.creditBalance),
        ownSum: _sumFormatter.format(balance),
        id: wallet.id,
        name: wallet.name,
        balance: _sumFormatter.format(wallet.creditBalance + balance),
      );
    }
    return DefaultWalletUIModel(
      id: wallet.id,
      name: wallet.name,
      balance: _sumFormatter.format(balance),
    );
  }
}
