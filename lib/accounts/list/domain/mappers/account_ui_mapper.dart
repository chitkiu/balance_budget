import '../../../common/data/models/account.dart';
import '../../ui/models/account_ui_model.dart';

class AccountUIMapper {
  AccountUIModel map(Account account, double balance) {
    return AccountUIModel(
      id: account.id,
      name: account.name,
      balance: balance.toString(),
    );
  }
}