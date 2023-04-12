import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/rich_transaction_model.dart';
import '../../common/data/rich_transaction_comparator.dart';
import '../../common/data/rich_transaction_mapper.dart';

class TransactionsAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();

  LocalTransactionsRepository get _transactionsRepository => Get.find();

  LocalWalletRepository get _walletRepository => Get.find();

  final RichTransactionMapper _mapper =
      const RichTransactionMapper(RichTransactionComparator());

  const TransactionsAggregator();

  Stream<List<RichTransactionModel>> transactionsByDate(
    DateTime start,
    DateTime end,
  ) {
    return CombineLatestStream.combine3(
      _categoryRepository.categories,
      _transactionsRepository.getTransactionByTimeRange(start, end),
      _walletRepository.wallets,
      _mapper.mapTransactions,
    );
  }

  Stream<RichTransactionModel?> transactionById(
    String id,
  ) {
    return CombineLatestStream.combine3(
      _categoryRepository.categories,
      _transactionsRepository.getTransactionById(id),
      _walletRepository.wallets,
      _mapper.mapTransaction,
    );
  }

  Stream<List<RichTransactionModel>> transactionByWalletId(
    String walletId,
  ) {
    return CombineLatestStream.combine3(
      _categoryRepository.categories,
      _transactionsRepository.getTransactionsByWalletId(walletId),
      _walletRepository.wallets,
      _mapper.mapTransactions,
    );
  }

  Stream<List<RichTransactionModel>> transactionByCategoryId(
    String categoryId,
  ) {
    return CombineLatestStream.combine3(
      _categoryRepository.getCategoryById(categoryId),
      _transactionsRepository.getTransactionsByCategoryId(categoryId),
      _walletRepository.wallets,
      _mapper.mapTransactionsWithPresetCategory,
    );
  }
}
