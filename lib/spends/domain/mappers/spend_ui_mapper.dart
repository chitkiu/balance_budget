import 'package:balance_budget/spends/data/models/rich_spend_model.dart';

import '../../../categories/data/models/category.dart';
import '../../data/models/spend.dart';
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