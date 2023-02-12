import 'dart:async';

import 'package:get/get.dart';

import '../../add/domain/add_transaction_binding.dart';
import '../../add/ui/add_transaction_screen.dart';
import '../data/transactions_aggregator.dart';
import '../ui/models/grouped_transactions_ui_model.dart';
import 'mappers/transactions_ui_mapper.dart';

class TransactionsController extends GetxController {
  TransactionsAggregator get _transactionsAggregator => Get.find();

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();
  RxList<GroupedTransactionsUIModel> transactions = <GroupedTransactionsUIModel>[].obs;
  StreamSubscription? _spendListener;

  @override
  void onReady() {
    _spendListener?.cancel();
    _spendListener = _transactionsAggregator.transactions().listen((event) {
      transactions.value = _transactionsUIMapper.mapGroup(event);
    });

    super.onReady();
  }

  @override
  void onClose() {
    _spendListener?.cancel();
    _spendListener = null;
    super.onClose();
  }

  void addTransaction() {
    Get.to(
      () => AddTransactionScreen(),
      binding: AddTransactionBinding()
    );
  }

}
