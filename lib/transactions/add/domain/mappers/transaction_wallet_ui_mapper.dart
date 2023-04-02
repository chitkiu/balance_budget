import '../../../../wallets/common/data/models/wallet.dart';
import '../../ui/models/transaction_wallet_ui_model.dart';

class TransactionWalletUIMapper {

  List<TransactionWalletUIModel> map(List<Wallet> wallets) {
    return wallets.map((category) {
      return TransactionWalletUIModel(
        category.id,
        category.name,
      );
    }).toList();
  }
}