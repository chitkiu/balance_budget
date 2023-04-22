import 'dart:async';

import 'package:balance_budget/wallets/common/data/wallet_balance_calculator.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/pair.dart';
import '../../add/domain/add_wallet_binding.dart';
import '../../add/ui/add_wallet_screen.dart';
import '../../common/data/local_wallet_repository.dart';
import '../../info/domain/wallet_info_binding.dart';
import '../../info/ui/wallet_info_screen.dart';
import '../data/filtered_transactions_repository.dart';
import '../ui/models/wallet_ui_model.dart';
import 'mappers/wallet_ui_mapper.dart';

class WalletsController extends GetxController with StateMixin<List<WalletUIModel>> {
  LocalWalletRepository get _walletRepo => Get.find();
  FilteredTransactionsRepository get _transactionRepo => Get.find();

  final WalletUIMapper _mapper = const WalletUIMapper();
  final WalletBalanceCalculator _calculator = const WalletBalanceCalculator();
  StreamSubscription? _walletsSubscription;

  @override
  void onInit() {
    super.onInit();

    _walletsSubscription ??= _getWallets().handleError((Object e, StackTrace str) {
      change(null, status: RxStatus.error(str.toString()));
    }).listen((categories) {
      if (categories.isNotEmpty) {
        change(categories, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    _walletsSubscription?.cancel();
    _walletsSubscription = null;
  }

  Stream<List<WalletUIModel>> _getWallets() {
    return CombineLatestStream.combine2(
        _transactionRepo.transactions(), _walletRepo.wallets, (a, b) {
      return Pair(a, b);
    }).map((value) {
      var transactionsData = value.first;
      var walletsData = value.second;
      return walletsData.map((e) {
        return _mapper.map(
            e, _calculator.calculateBalance(transactionsData, e));
      }).toList();
    });
  }

  void onAddClick() {
    Get.to(
      () => AddWalletScreen(),
      binding: AddWalletBinding(),
    );
  }

  void onItemClick(WalletUIModel wallet) {
    Get.to(() => WalletInfoScreen(), binding: WalletInfoBinding(wallet.id));
  }
}
