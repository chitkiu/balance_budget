import '../../../../categories/common/data/models/category.dart';
import '../../../../common/ui/common_selection_list.dart';

class TransactionCategoryUIMapper {

  List<SelectionListItem<Category>> map(List<Category> categories, Category? selectedCategory) {
    return categories.map((category) {
      return SelectionListItem(
        model: category,
        name: category.title,
        isSelected: category.id == selectedCategory?.id,
      );
    }).toList();
  }
}