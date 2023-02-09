import '../../../../categories/common/data/models/category.dart';
import '../../../common/data/models/spend.dart';

class RichSpendModel {
  final Spend spend;
  final Category category;

  RichSpendModel(this.spend, this.category);
}