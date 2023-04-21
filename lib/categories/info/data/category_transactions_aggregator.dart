import 'package:get/get.dart';
import 'package:rxdart/streams.dart';

import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../../transactions/common/data/models/rich_transaction_model.dart';
import '../../../transactions/common/data/rich_transaction_comparator.dart';
import '../../../transactions/common/data/rich_transaction_mapper.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../common/data/local_category_repository.dart';

class CategoryTransactionsAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();

  LocalTransactionsRepository get _transactionsRepository => Get.find();

  LocalWalletRepository get _walletRepository => Get.find();

  final RichTransactionMapper _mapper = const RichTransactionMapper(RichTransactionComparator());

  const CategoryTransactionsAggregator();

  Stream<List<RichTransactionModel>> transactionByCategoryId(String categoryId) {
    return CombineLatestStream.combine3(
      _categoryRepository.categoryById(categoryId),
      _transactionsRepository.transactionsByCategoryId(categoryId),
      _walletRepository.walletsWithoutArchived,
      _mapper.mapTransactionsWithPresetCategory,
    );
  }

}
