import '../../../../categories/common/data/models/category_id.dart';

class SpendCategoryUIModel {
  final CategoryId categoryId;
  final String title;
  final bool isSelected;

  SpendCategoryUIModel(this.categoryId, this.title, this.isSelected);
}