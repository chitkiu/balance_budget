import 'package:get/get.dart';
import 'package:rxdart/streams.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../../transactions/common/data/models/transaction.dart';

class FilteredTransactionsRepository {

  LocalCategoryRepository get _categoryRepository => Get.find();

  LocalTransactionsRepository get _transactionsRepository => Get.find();

  const FilteredTransactionsRepository();

  Stream<List<Transaction>> transactions() {
    return CombineLatestStream.combine2(
        _categoryRepository.categoriesWithoutArchived,
        _transactionsRepository.transactions,
            (categories, transactions) {
          return transactions.where((transaction) {
            return categories.any((category) {
              if (transaction is CommonTransaction) {
                return category.id == transaction.categoryId;
              } else {
                return true;
              }
            });
          }).toList();
            });
  }
}