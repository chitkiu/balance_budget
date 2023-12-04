import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/rich_transaction_model.dart';
import '../../common/data/rich_transaction_comparator.dart';
import '../../common/data/rich_transaction_mapper.dart';
import '../domain/models/transactions_filter_date.dart';

class TransactionsAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();

  final LocalTransactionsRepository _transactionsRepository;

  LocalWalletRepository get _walletRepository => Get.find();

  final RichTransactionMapper _mapper =
      const RichTransactionMapper(RichTransactionComparator());

  const TransactionsAggregator(this._transactionsRepository);

  Stream<List<RichTransactionModel>> transactionsByDate(
      TransactionsFilterDate dateRange) {
    return CombineLatestStream.combine3(
      _categoryRepository.categoriesWithoutArchived,
      _transactionsRepository.transactionByTimeRange(dateRange.start, dateRange.end),
      _walletRepository.wallets,
      _mapper.mapTransactions,
    ).map((transactions) {
      return transactions.where((transaction) {
        ///Filter only if it's default transaction, if it transfer - we should show it, because it's impact wallet info
        ///Or hide transfer on all screen, decide it later
        if (transaction is CategoryRichTransactionModel) {
          return !transaction.fromWallet.archived;
        } else {
          return true;
        }
      }).toList();
    });
  }

  Stream<RichTransactionModel?> transactionById(String id) {
    return CombineLatestStream.combine3(
      _categoryRepository.categories,
      _transactionsRepository.transactionById(id),
      _walletRepository.wallets,
      _mapper.mapTransaction,
    );
  }
}
