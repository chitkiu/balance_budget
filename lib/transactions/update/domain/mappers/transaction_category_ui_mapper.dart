import '../../../../categories/common/data/models/category.dart';
import '../../../../common/data/models/transaction_type.dart';
import '../../../../common/ui/common_selection_list.dart';

class TransactionCategoryUIMapper {

  List<SelectionListItem<Category>> map(List<Category> categories, Category? selectedCategory, TransactionType transactionType) {
    var filteredCategories = categories.where((element) => element.transactionType == transactionType);
    return filteredCategories.map((category) {
      return SelectionListItem(
        model: category,
        name: category.title,
        isSelected: category.id == selectedCategory?.id,
      );
    }).toList();
  }
}