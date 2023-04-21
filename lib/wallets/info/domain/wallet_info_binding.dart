import 'package:balance_budget/wallets/info/domain/wallet_info_controller.dart';
import 'package:get/get.dart';

import '../../../transactions/list/data/transactions_aggregator.dart';
import '../data/wallet_transactions_aggregator.dart';

class WalletInfoBinding extends Bindings {
  final String id;

  WalletInfoBinding(this.id);

  @override
  void dependencies() {
    Get.lazyPut(() => const WalletTransactionAggregator());
    ///Added for transaction info screen
    Get.lazyPut(() => const TransactionsAggregator());
    Get.put(WalletInfoController(id));
  }
}
