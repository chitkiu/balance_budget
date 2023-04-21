import 'package:get/get.dart';
import 'package:rxdart/streams.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../../transactions/common/data/models/rich_transaction_model.dart';
import '../../../transactions/common/data/rich_transaction_comparator.dart';
import '../../../transactions/common/data/rich_transaction_mapper.dart';
import '../../common/data/local_wallet_repository.dart';

class WalletTransactionAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();

  LocalTransactionsRepository get _transactionsRepository => Get.find();

  LocalWalletRepository get _walletRepository => Get.find();

  final RichTransactionMapper _mapper = const RichTransactionMapper(RichTransactionComparator());

  const WalletTransactionAggregator();

  Stream<List<RichTransactionModel>> transactionByWalletId(String walletId,) {
    return CombineLatestStream.combine3(
      _categoryRepository.categoriesWithoutArchived,
      _transactionsRepository.transactionsByWalletId(walletId),
      _walletRepository.wallets,
      _mapper.mapTransactions,
    );
  }
}