import 'dart:async';

import 'package:get/get.dart';
import 'package:rxdart/transformers.dart';

import '../../../common/ui/transaction_item/mappers/transactions_header_ui_mapper.dart';
import '../../../common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import '../../../transactions/common/data/models/rich_transaction_model.dart';
import '../../../transactions/common/data/rich_transaction_comparator.dart';
import '../../../transactions/list/data/transactions_aggregator.dart';
import '../../common/data/local_wallet_repository.dart';
import '../../common/data/models/wallet.dart';
import '../../common/data/wallet_balance_calculator.dart';
import '../../list/domain/mappers/wallet_ui_mapper.dart';
import '../ui/models/rich_wallet_ui_model.dart';

class WalletInfoController extends GetxController
    with StateMixin<RichWalletUIModel> {
  final String id;

  WalletInfoController(this.id);

  LocalWalletRepository get _walletRepo => Get.find();
  TransactionsAggregator get _transactionsAggregator => Get.find();

  final WalletUIMapper _walletUIMapper = const WalletUIMapper();

  final TransactionsHeaderUIMapper _transactionsHeaderUIMapper =
      TransactionsHeaderUIMapper(
    const RichTransactionComparator(),
    TransactionsUIMapper(),
  );
  final WalletBalanceCalculator _calculator = const WalletBalanceCalculator();

  StreamSubscription? _walletSubscription;

  @override
  void onInit() {
    super.onInit();

    _walletSubscription ??= _walletRepo.walletById(id).switchMap((wallet) {
      if (wallet == null) {
        return const Stream.empty();
      } else {
        return _transactionsAggregator
            .transactionByWalletId(wallet.id)
            .map((transactions) => _mapToUIModel(wallet, transactions));
      }
    }).handleError((Object e, StackTrace str) {
      change(null, status: RxStatus.error(str.toString()));
    }).listen((event) {
      if (event is RichWalletUIModel &&
          event.transactions.transactionCount != 0) {
        change(event, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    _walletSubscription?.cancel();
    _walletSubscription = null;
  }

  RichWalletUIModel _mapToUIModel(
      Wallet wallet, List<RichTransactionModel> transactions) {
    return RichWalletUIModel(
        _walletUIMapper.map(
            wallet, _calculator.calculateBalanceFromRich(transactions, wallet)),
        _transactionsHeaderUIMapper.mapTransactionsToUI(transactions));
  }
}
