import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/spend.dart';

class RichSpendModel {
  final Spend spend;
  final Category category;
  final Account account;

  RichSpendModel(this.spend, this.category, this.account);
}
