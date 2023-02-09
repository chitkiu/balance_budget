import '../../../../categories/common/data/models/category_id.dart';
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

  Spend copyWith({double? sum, CategoryId? categoryId, DateTime? time, String? comment}) {
    return Spend(
      id: this.id,
      sum: sum ?? this.sum,
      categoryId: categoryId ?? this.categoryId,
      time: time ?? this.time,
      comment: comment ?? this.comment,
    );
  }

  @override
  String toString() {
    return 'Spend{id: $id, sum: $sum, categoryId: $categoryId, time: $time, comment: $comment}';
  }
}
