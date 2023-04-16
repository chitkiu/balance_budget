import '../../../../common/ui/common_selection_list.dart';
import '../../../../wallets/common/data/models/wallet.dart';

class TransactionWalletUIMapper {

  List<SelectionListItem<String>> map(List<Wallet> wallets, String? selectedWalletId) {
    return wallets.map((wallet) {
      return SelectionListItem(
        model: wallet.id,
        name: wallet.name,
        isSelected: selectedWalletId == wallet.id,
      );
    }).toList();
  }
}