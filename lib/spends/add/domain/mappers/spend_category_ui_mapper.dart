import '../../../../categories/common/data/models/category.dart';
import '../../../../categories/common/data/models/category_id.dart';
import '../../ui/models/spend_category_ui_model.dart';

class SpendCategoryUIMapper {

  List<SpendCategoryUIModel> map(List<Category> categories, CategoryId? selectedCategory) {
    return categories.map((category) {
      return SpendCategoryUIModel(
        category.id,
        category.title,
        category.id == selectedCategory,
      );
    }).toList();
  }
}