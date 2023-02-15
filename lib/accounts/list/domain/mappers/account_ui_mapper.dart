import '../../../common/data/models/account.dart';
import '../../ui/models/account_ui_model.dart';

class AccountUIMapper {
  AccountUIModel map(Account account, double balance) {
    if (account is CreditAccount) {
      return CreditAccountUIModel(
          creditSum: account.creditBalance.toString(),
          ownSum: balance.toString(),
          id: account.id,
          name: account.name,
          balance: (account.creditBalance+balance).toString()
      );
    }
    return DefaultAccountUIModel(
      id: account.id,
      name: account.name,
      balance: balance.toString(),
    );
  }
}