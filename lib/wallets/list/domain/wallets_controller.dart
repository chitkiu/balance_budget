import 'dart:async';

import 'package:balance_budget/wallets/common/data/wallet_balance_calculator.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/pair.dart';
import '../../../transactions/common/data/local_transactions_repository.dart';
import '../../add/domain/add_wallet_binding.dart';
import '../../add/ui/add_wallet_screen.dart';
import '../../common/data/local_wallet_repository.dart';
import '../../info/domain/wallet_info_binding.dart';
import '../../info/ui/wallet_info_screen.dart';
import '../ui/models/wallet_ui_model.dart';
import 'mappers/wallet_ui_mapper.dart';

class WalletsController extends GetxController {
  LocalWalletRepository get _walletRepo => Get.find();
  LocalTransactionsRepository get _transactionRepo => Get.find();

  final WalletUIMapper _mapper = const WalletUIMapper();
  final WalletBalanceCalculator _calculator = const WalletBalanceCalculator();

  Stream<List<WalletUIModel>> getWallets() {
    return CombineLatestStream.combine2(
        _transactionRepo.transactions, _walletRepo.wallets, (a, b) {
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
    WalletInfoScreen(
      bindingCreator: () => WalletInfoBinding(wallet.id),
    ).open();
  }
}
