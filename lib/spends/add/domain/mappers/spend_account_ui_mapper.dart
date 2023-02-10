import '../../../../accounts/common/data/models/account.dart';
import '../../../../accounts/common/data/models/account_id.dart';
import '../../ui/models/spend_account_ui_model.dart';

class SpendAccountUIMapper {

  List<SpendAccountUIModel> map(List<Account> categories, AccountId? selectedCategory) {
    return categories.map((category) {
      return SpendAccountUIModel(
        category.id,
        category.name,
        category.id == selectedCategory,
      );
    }).toList();
  }
}