import '../../../common/data/models/account.dart';
import '../../ui/models/account_ui_model.dart';

class AccountUIMapper {
  AccountUIModel map(Account account) {
    return AccountUIModel(
      account.name,
      account.id,
    );
  }
}