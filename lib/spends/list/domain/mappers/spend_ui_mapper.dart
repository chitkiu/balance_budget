import 'package:balance_budget/spends/list/data/models/rich_spend_model.dart';

import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/spend.dart';
import '../../ui/models/spend_ui_model.dart';

class SpendUIMapper {
  const SpendUIMapper();

  SpendUIModel map(Spend spend, Category category) {
    return SpendUIModel(
        sum: spend.sum.toString(),
        categoryName: category.title,
    );
  }

  SpendUIModel mapFromRich(RichSpendModel richSpend) {
    return map(richSpend.spend, richSpend.category);
  }

}