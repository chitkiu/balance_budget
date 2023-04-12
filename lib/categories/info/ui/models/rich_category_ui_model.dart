import '../../../../common/ui/transaction_item/models/complex_transactions_ui_model.dart';
import '../../../list/ui/models/category_ui_model.dart';

class RichCategoryUIModel {
  final CategoryUIModel category;
  final ComplexTransactionsUIModel transactions;

  const RichCategoryUIModel(this.category, this.transactions);
}
