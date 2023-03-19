import 'dart:async';

import 'package:get/get.dart';

import '../../add/domain/add_transaction_binding.dart';
import '../../add/ui/add_transaction_screen.dart';
import '../../info/domain/transaction_info_binding.dart';
import '../../info/ui/transaction_info_screen.dart';
import '../data/transactions_aggregator.dart';
import '../ui/models/transaction_ui_model.dart';
import 'mappers/transactions_ui_mapper.dart';

class TransactionsController extends GetxController {
  TransactionsAggregator get _transactionsAggregator => Get.find();

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();
  RxList<TransactionUIModel> transactions = <TransactionUIModel>[].obs;
  StreamSubscription? _spendListener;

  @override
  void onReady() {
    _spendListener?.cancel();
    _spendListener = _transactionsAggregator.transactions().listen((event) {
      transactions.value = event.map(_transactionsUIMapper.mapFromRich).toList();
    });

    super.onReady();
  }

  @override
  void onClose() {
    _spendListener?.cancel();
    _spendListener = null;
    super.onClose();
  }

  List<TransactionUIModel> getItemsFromMonth(DateTime dateTime) {
    return transactions.where((item) {
      return item.dateTime.year == dateTime.year &&
          item.dateTime.month == dateTime.month &&
          item.dateTime.day == dateTime.day;
    }).toList();
  }

  void addTransaction() {
    Get.to(
      () => AddTransactionScreen(),
      binding: AddTransactionBinding()
    );
  }

  void onItemClick(TransactionUIModel transaction) async {
    var binding = TransactionInfoBinding();
    binding.dependencies();
    await Get.bottomSheet(
        TransactionInfoScreen(transaction.id),
    );
    binding.delete();
    // showCupertinoModalPopup(context: context, builder: builder)
    /*Get.to(
      () => TransactionInfoScreen(transaction.id),
      binding: TransactionInfoBinding(),
    );*/
  }

}
