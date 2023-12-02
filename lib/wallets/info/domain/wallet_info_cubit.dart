import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/transaction_item/mappers/transactions_header_ui_mapper.dart';
import '../../../common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';
import '../../../transactions/common/data/models/rich_transaction_model.dart';
import '../../../transactions/common/data/rich_transaction_comparator.dart';
import '../../../transactions/info/domain/transaction_info_controller.dart';
import '../../../transactions/info/ui/transaction_info_screen.dart';
import '../../common/data/local_wallet_repository.dart';
import '../../common/data/models/wallet.dart';
import '../../common/data/wallet_balance_calculator.dart';
import '../../list/domain/mappers/wallet_ui_mapper.dart';
import '../data/wallet_transactions_aggregator.dart';
import '../ui/models/rich_wallet_ui_model.dart';
import 'wallet_info_state.dart';

class WalletInfoCubit extends Cubit<WalletInfoState> {
  final String id;

  final LocalWalletRepository _walletRepo;
  final WalletTransactionAggregator _transactionsAggregator =
      const WalletTransactionAggregator();

  final WalletUIMapper _walletUIMapper = const WalletUIMapper();
  final WalletBalanceCalculator _calculator = const WalletBalanceCalculator();
  final TransactionsHeaderUIMapper _transactionsHeaderUIMapper =
  TransactionsHeaderUIMapper(
    const RichTransactionComparator(),
    TransactionsUIMapper(),
  );

  StreamSubscription? _walletSubscription;

  WalletInfoCubit(this.id, this._walletRepo)
      : super(WalletInfoState(WalletInfoStatus.initial, null, null)) {
    emit(state.copyWith(
      status: WalletInfoStatus.loading,
    ));
    _walletSubscription ??= _getWalletInfo(id).handleError((Object e, StackTrace str) {
      emit(state.copyWith(
        status: WalletInfoStatus.failure,
        error: str.toString(),
      ));
    }).listen((wallet) {
      emit(state.copyWith(
        status: WalletInfoStatus.success,
        model: wallet,
        error: null,
      ));
    });
  }

  @override
  Future<void> close() async {
    await _walletSubscription?.cancel();
    _walletSubscription = null;
    await super.close();
  }

  Future<void> archiveWallet() async {
    final wallet = await _walletRepo.getWalletById(id);

    if (wallet != null) {
      await _walletRepo.edit(wallet.id, archived: !wallet.archived);
    }
  }

  Future<void> deleteWallet() async {
    await _walletRepo.delete(id);
  }

  void onTransactionClicked(BuildContext context, TransactionUIModel transaction, bool canEdit) {
    openModalSheetWithController(
      context,
          (controller) {
        return TransactionInfoScreen(controller: controller,);
      },
      TransactionInfoController(transaction.id, canEdit),
    );
  }

  Stream<RichWalletUIModel?> _getWalletInfo(String id) {
   return _walletRepo.walletById(id).switchMap((wallet) {
      if (wallet == null) {
        return Stream.value(null);
      } else {
        return _transactionsAggregator
            .transactionByWalletId(wallet.id)
            .map((transactions) => _mapToUIModel(wallet, transactions));
      }
    });
  }

  RichWalletUIModel _mapToUIModel(
      Wallet wallet, List<RichTransactionModel> transactions) {
    return RichWalletUIModel(
        _walletUIMapper.map(
            wallet, _calculator.calculateBalanceFromRich(transactions, wallet)),
        _transactionsHeaderUIMapper.mapTransactionsToUI(transactions));
  }
}
