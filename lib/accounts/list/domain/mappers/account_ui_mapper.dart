import 'package:intl/intl.dart';

import '../../../common/data/models/account.dart';
import '../../ui/models/account_ui_model.dart';

final NumberFormat _sumFormatter = NumberFormat("##0.00");

class AccountUIMapper {
  AccountUIModel map(Account account, double balance) {
    if (account is CreditAccount) {
      return CreditAccountUIModel(
          creditSum: _sumFormatter.format(account.creditBalance),
          ownSum: _sumFormatter.format(balance),
          id: account.id,
          name: account.name,
          balance: _sumFormatter.format(account.creditBalance+balance),
      );
    }
    return DefaultAccountUIModel(
      id: account.id,
      name: account.name,
      balance: _sumFormatter.format(balance),
    );
  }
}