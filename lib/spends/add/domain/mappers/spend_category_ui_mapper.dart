import '../../../../categories/common/data/models/category.dart';
import '../../../../categories/common/data/models/category_id.dart';
import '../../ui/models/spend_category_ui_model.dart';

class SpendCategoryUIMapper {

  List<SpendCategoryUIModel> map(List<Category> categories, CategoryId? selectedCategory) {
    return categories.map((category) {
      return SpendCategoryUIModel(
        category.id,
        _getTitle(category, categories),
        category.id == selectedCategory,
      );
    }).toList();
  }

  //TODO Should think about root category and maybe move it to some common part
  String _getTitle(Category current, List<Category> categories) {
    if (current.rootCategory == null) {
      return current.title;
    } else {
      var root = categories.firstWhere((element) => element.id == current.rootCategory);
      return "${_getTitle(root, categories)}/${current.title}";
    }
  }
}