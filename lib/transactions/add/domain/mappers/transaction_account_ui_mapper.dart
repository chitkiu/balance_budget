import '../../../../accounts/common/data/models/account.dart';
import '../../ui/models/transaction_account_ui_model.dart';

class TransactionAccountUIMapper {

  List<TransactionAccountUIModel> map(List<Account> categories, String? selectedCategory) {
    return categories.map((category) {
      return TransactionAccountUIModel(
        category.id,
        category.name,
        category.id == selectedCategory,
      );
    }).toList();
  }
}