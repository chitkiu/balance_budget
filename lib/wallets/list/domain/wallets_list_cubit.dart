import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/pair.dart';
import '../../add/domain/add_wallet_binding.dart';
import '../../add/ui/add_wallet_screen.dart';
import '../../common/data/local_wallet_repository.dart';
import '../../common/data/wallet_balance_calculator.dart';
import '../data/filtered_transactions_repository.dart';
import '../ui/models/wallet_ui_model.dart';
import 'mappers/wallet_ui_mapper.dart';
import 'wallets_list_state.dart';

class WalletsListCubit extends Cubit<WalletsListState> {
  final LocalWalletRepository _walletRepo;
  final FilteredTransactionsRepository _transactionRepo =
      const FilteredTransactionsRepository();
  final WalletUIMapper _mapper = const WalletUIMapper();
  final WalletBalanceCalculator _calculator = const WalletBalanceCalculator();

  StreamSubscription? _walletsSubscription;

  WalletsListCubit(this._walletRepo)
      : super(WalletsListState(WalletsListStatus.initial, List.empty(), null)) {
    emit(state.copyWith(
      status: WalletsListStatus.loading,
    ));
    _walletsSubscription ??= _getWallets().handleError((Object e, StackTrace str) {
      emit(state.copyWith(
        status: WalletsListStatus.failure,
        error: str.toString(),
      ));
    }).listen((wallets) {
      emit(state.copyWith(
        status: WalletsListStatus.success,
        items: wallets,
        error: null,
      ));
    });
  }

  @override
  Future<void> close() async {
    await _walletsSubscription?.cancel();
    _walletsSubscription = null;
    await super.close();
  }

  Stream<List<WalletUIModel>> _getWallets() {
    return CombineLatestStream.combine2(
        _transactionRepo.transactions(), _walletRepo.wallets, (a, b) {
      return Pair(a, b);
    }).map((value) {
      var transactionsData = value.first;
      var walletsData = value.second;
      return walletsData.map((e) {
        return _mapper.map(e, _calculator.calculateBalance(transactionsData, e));
      }).toList();
    });
  }

  void onAddClick() {
    Get.to(
      () => AddWalletScreen(),
      binding: AddWalletBinding(),
    );
  }
}
