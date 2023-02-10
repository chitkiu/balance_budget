import '../../../../accounts/common/data/models/account.dart';
import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/spend.dart';
import '../../data/models/rich_spend_model.dart';
import '../../ui/models/spend_ui_model.dart';

class SpendUIMapper {
  const SpendUIMapper();

  SpendUIModel map(Spend spend, Category category, Account account) {
    return SpendUIModel(
      sum: spend.sum.toString(),
      categoryName: category.title,
      accountName: account.name,
      time: spend.time.toString(),
      comment: spend.comment,
    );
  }

  SpendUIModel mapFromRich(RichSpendModel richSpend) {
    return map(richSpend.spend, richSpend.category, richSpend.account);
  }
}
