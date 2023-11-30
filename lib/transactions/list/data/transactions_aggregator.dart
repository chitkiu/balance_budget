import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/rich_transaction_model.dart';
import '../../common/data/rich_transaction_comparator.dart';
import '../../common/data/rich_transaction_mapper.dart';
import '../domain/selected_transactions_date_storage.dart';

class TransactionsAggregator {
  LocalCategoryRepository get _categoryRepository => Get.find();

  LocalTransactionsRepository get _transactionsRepository => Get.find();

  LocalWalletRepository get _walletRepository => Get.find();

  SelectedTransactionsDateStorage get _dateStorage => Get.find();

  final RichTransactionMapper _mapper =
      const RichTransactionMapper(RichTransactionComparator());

  const TransactionsAggregator();

  Stream<List<RichTransactionModel>> transactionsByDate() {
    return CombineLatestStream.combine3(
      _categoryRepository.categoriesWithoutArchived,
      _dateStorage.currentDateStream.switchMap(
              (dateRange) =>
              _transactionsRepository.transactionByTimeRange(
                  dateRange.start, dateRange.end)
      ),
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
