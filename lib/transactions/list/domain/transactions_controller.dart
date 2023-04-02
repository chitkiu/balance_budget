import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:rxdart/transformers.dart';

import '../../../common/getx_extensions.dart';
import '../../info/domain/transaction_info_binding.dart';
import '../../info/ui/transaction_info_screen.dart';
import '../../update/domain/update_transaction_binding.dart';
import '../../update/ui/update_transaction_screen.dart';
import '../data/models/rich_transaction_model.dart';
import '../data/transactions_aggregator.dart';
import '../ui/models/complex_transactions_ui_model.dart';
import '../ui/models/transaction_header_ui_model.dart';
import '../ui/models/transaction_ui_model.dart';
import 'mappers/transactions_ui_mapper.dart';
import 'models/transactions_filter_date.dart';
import 'selected_transactions_date_storage.dart';

class TransactionsController extends GetxController
    with StateMixin<ComplexTransactionsUIModel> {
  TransactionsAggregator get _transactionsAggregator => Get.find();

  SelectedTransactionsDateStorage get _dateStorage => Get.find();

  late final Rx<TransactionsFilterDate> currentDate;

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();

  Rx<ComplexTransactionsUIModel> transactions = ComplexTransactionsUIModel(0, []).obs;

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
      if (event.transactions.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(event, status: RxStatus.success());
      }
      return event;
    }));
  }

  void addTransaction() {
    UpdateTransactionScreen(
      title: Get.localisation.addTransactionTitle,
      bindingCreator: () => UpdateTransactionBinding(),
    ).open();
  }

  void onItemClick(TransactionUIModel transaction) {
    TransactionInfoScreen(bindingCreator: () => TransactionInfoBinding(transaction.id))
        .open();
  }

  void setNewDate(TransactionsFilterDate date) {
    _dateStorage.setNewDate(date);
  }

  ComplexTransactionsUIModel _mapTransactionsToUI(
      List<RichTransactionModel> filteredTransaction) {
    List<TransactionHeaderUIModel> groupedTransactions = [];

    var totalTransactionCount = 0;

    groupBy(filteredTransaction, (item) => item.transaction.time)
        .entries
        .sortedBy((element) => element.key)
        .reversed
        .forEach((element) {
      var transactions = element.value;
      transactions.sort(_transactionsAggregator.compare);
      var transactionsUIModels =
          transactions.map(_transactionsUIMapper.mapFromRich).whereNotNull();
      totalTransactionCount += transactionsUIModels.length;
      groupedTransactions.add(_transactionsUIMapper.mapHeader(
          element.key, transactions, transactionsUIModels));
    });

    return ComplexTransactionsUIModel(
        totalTransactionCount,
        groupedTransactions
    );
  }
}
