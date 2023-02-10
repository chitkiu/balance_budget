import '../../../../categories/common/data/models/category_id.dart';

class TransactionCategoryUIModel {
  final CategoryId categoryId;
  final String title;
  final bool isSelected;

  TransactionCategoryUIModel(this.categoryId, this.title, this.isSelected);
}