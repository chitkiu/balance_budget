import '../../../categories/data/models/category_id.dart';
import 'spend_id.dart';

class Spend {
  final SpendId id;
  final double sum;
  final CategoryId categoryId;
  final DateTime time;
  final String? comment;

  Spend(
      {required this.id,
      required this.sum,
      required this.categoryId,
      required this.time,
      this.comment});
}
