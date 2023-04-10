import '../../../../common/ui/transaction_item/models/complex_transactions_ui_model.dart';
import '../../../list/ui/models/wallet_ui_model.dart';

class RichWalletUIModel {
  final WalletUIModel wallet;
  final ComplexTransactionsUIModel transactions;

  const RichWalletUIModel(this.wallet, this.transactions);
}
