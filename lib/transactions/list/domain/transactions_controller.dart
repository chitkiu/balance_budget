import 'dart:async';

import 'package:collection/collection.dart';
import 'package:get/get.dart';

import '../../../common/data/date_time_extension.dart';
import '../../add/domain/add_transaction_binding.dart';
import '../../add/ui/add_transaction_screen.dart';
import '../../info/domain/transaction_info_binding.dart';
import '../../info/ui/transaction_info_screen.dart';
import '../data/transactions_aggregator.dart';
import '../ui/models/transaction_list_ui_model.dart';
import '../ui/models/transaction_ui_model.dart';
import 'mappers/transactions_ui_mapper.dart';
import 'models/transactions_filter_date.dart';
import 'selected_transactions_date_storage.dart';

class TransactionsController extends GetxController {
  TransactionsAggregator get _transactionsAggregator => Get.find();
  SelectedTransactionsDateStorage get _dateStorage => Get.find();

  Rx<TransactionsFilterDate> get currentDate => _dateStorage.currentDate;

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();

  Stream<List<TransactionListUIModel>> getItemsFromDayRange(TransactionsFilterDate dateTime) {
    return _transactionsAggregator.transactions().map((items) {
      var filteredTransaction = items.where((item) {
        return item.transaction.time.isAfterOrAtSameMoment(dateTime.start) &&
            item.transaction.time.isBeforeOrAtSameMoment(dateTime.end);
      });

      List<TransactionListUIModel> groupedTransactions = [];

      groupBy(filteredTransaction, (item) => item.transaction.time)
          .entries
          .sortedBy((element) => element.key)
          .reversed
          .forEach((element) {
        var transactions = element.value;
        transactions.sort(_transactionsAggregator.compare);
        var transactionsUIModels = transactions.map(_transactionsUIMapper.mapFromRich)
            .whereNotNull();
        groupedTransactions.add(
            _transactionsUIMapper.mapHeader(element.key, transactionsUIModels));
        groupedTransactions.addAll(transactionsUIModels);
      });

      return groupedTransactions;
    });
  }

  void addTransaction() {
    Get.to(() => AddTransactionScreen(), binding: AddTransactionBinding());
  }

  void onItemClick(TransactionUIModel transaction) async {
    var binding = TransactionInfoBinding();
    binding.dependencies();
    await Get.bottomSheet(
      TransactionInfoScreen(transaction.id),
    );
    binding.delete();
  }
}
