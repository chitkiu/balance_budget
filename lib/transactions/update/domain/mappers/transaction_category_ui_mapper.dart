import '../../../../categories/common/data/models/category.dart';
import '../../../../common/data/models/transaction_type.dart';
import '../../../../common/ui/common_selection_list.dart';

class TransactionCategoryUIMapper {

  List<SelectionListItem<String>> map(List<Category> categories, String? selectedCategory, TransactionType transactionType) {
    var filteredCategories = categories.where((element) => element.transactionType == transactionType);
    return filteredCategories.map((category) {
      return SelectionListItem(
        model: category.id,
        name: category.title,
        isSelected: category.id == selectedCategory,
      );
    }).toList();
  }
}