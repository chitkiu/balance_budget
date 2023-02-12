import '../../../../categories/common/data/models/category.dart';
import '../../../../common/data/models/transaction_type.dart';
import '../../ui/models/transaction_category_ui_model.dart';

class TransactionCategoryUIMapper {

  List<TransactionCategoryUIModel> map(List<Category> categories, String? selectedCategory, TransactionType transactionType) {
    var filteredCategories = categories.where((element) => element.transactionType == transactionType);
    return filteredCategories.map((category) {
      return TransactionCategoryUIModel(
        category.id,
        category.title,
        category.id == selectedCategory,
      );
    }).toList();
  }
}