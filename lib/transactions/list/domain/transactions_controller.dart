import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:rxdart/transformers.dart';

import '../../add/domain/add_transaction_binding.dart';
import '../../add/ui/add_transaction_screen.dart';
import '../../info/domain/transaction_info_binding.dart';
import '../../info/ui/transaction_info_screen.dart';
import '../data/models/rich_transaction_model.dart';
import '../data/transactions_aggregator.dart';
import '../ui/models/transaction_list_ui_model.dart';
import '../ui/models/transaction_ui_model.dart';
import 'mappers/transactions_ui_mapper.dart';
import 'models/transactions_filter_date.dart';
import 'selected_transactions_date_storage.dart';

class TransactionsController extends GetxController
    with StateMixin<List<TransactionListUIModel>> {
  TransactionsAggregator get _transactionsAggregator => Get.find();

  SelectedTransactionsDateStorage get _dateStorage => Get.find();

  late final Rx<TransactionsFilterDate> currentDate;

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();

  RxList<TransactionListUIModel> transactions = <TransactionListUIModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    currentDate = _dateStorage.currentDateStream.value.obs;

    currentDate.bindStream(_dateStorage.currentDateStream);

    transactions.bindStream(_dateStorage.currentDateStream.switchMap((dateRange) {
      return _transactionsAggregator
          .transactionsByDate(dateRange.start, dateRange.end)
          .map(_mapTransactionsToUI);
    }).handleError((Object e, StackTrace str) {
      change(null, status: RxStatus.error(str.toString()));
    }).map((event) {
      if (event.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(event, status: RxStatus.success());
      }
      return event;
    }));
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

  void setNewDate(TransactionsFilterDate date) {
    _dateStorage.setNewDate(date);
  }

  List<TransactionListUIModel> _mapTransactionsToUI(
      List<RichTransactionModel> filteredTransaction) {
    List<TransactionListUIModel> groupedTransactions = [];

    groupBy(filteredTransaction, (item) => item.transaction.time)
        .entries
        .sortedBy((element) => element.key)
        .reversed
        .forEach((element) {
      var transactions = element.value;
      transactions.sort(_transactionsAggregator.compare);
      var transactionsUIModels =
          transactions.map(_transactionsUIMapper.mapFromRich).whereNotNull();
      groupedTransactions
          .add(_transactionsUIMapper.mapHeader(element.key, transactionsUIModels));
      groupedTransactions.addAll(transactionsUIModels);
    });

    return groupedTransactions;
  }
}
