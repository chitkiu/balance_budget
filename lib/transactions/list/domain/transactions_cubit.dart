import 'dart:async';

import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/pair.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/transaction_item/mappers/transactions_header_ui_mapper.dart';
import '../../../common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import '../../../common/ui/transaction_item/models/complex_transactions_ui_model.dart';
import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';
import '../../common/data/rich_transaction_comparator.dart';
import '../../info/domain/transaction_info_controller.dart';
import '../../info/ui/transaction_info_screen.dart';
import '../../update/domain/update_transaction_controller.dart';
import '../../update/ui/update_transaction_screen.dart';
import '../data/transactions_aggregator.dart';
import 'models/transactions_filter_date.dart';
import 'selected_transactions_date_storage.dart';
import 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsAggregator _transactionsAggregator = const TransactionsAggregator();
  final SelectedTransactionsDateStorage _dateStorage;
  final TransactionsHeaderUIMapper _transactionsHeaderUIMapper =
      TransactionsHeaderUIMapper(
    const RichTransactionComparator(),
    TransactionsUIMapper(),
  );

  StreamSubscription? _transactionsSubscription;

  TransactionsCubit(this._dateStorage)
      : super(TransactionsState(TransactionsStatus.initial, null, null, null)) {
    _transactionsSubscription ??=
        _transactionsStream().handleError((Object e, StackTrace str) {
      emit(state.copyWith(status: TransactionsStatus.failure, error: str.toString()));
    }).listen((pair) {
      emit(state.copyWith(status: TransactionsStatus.success, model: pair.second, date: pair.first, error: null));
    });
  }

  @override
  Future<void> close() async {
    _transactionsSubscription?.cancel();
    await super.close();
  }

  void setNewDate(List<DateTime> newDate) {
    if (newDate.length == 1) {
      _dateStorage.setNewDate(TransactionsFilterDate(
        start: newDate.first,
        end: newDate.first,
      ));
    } else if (newDate.length == 2) {
      _dateStorage.setNewDate(TransactionsFilterDate(
        start: newDate.first,
        end: newDate[1],
      ));
    }
  }

  void addTransaction(BuildContext context) {
    openModalSheetWithController(
      context,
      (controller) {
        return UpdateTransactionScreen(
          title: Get.localisation.addTransactionTitle,
          controller: controller,
        );
      },
      UpdateTransactionController(),
    );
  }

  void onItemClick(BuildContext context, TransactionUIModel transaction) {
    openModalSheetWithController(
      context,
      (controller) {
        return TransactionInfoScreen(
          controller: controller,
        );
      },
      TransactionInfoController(transaction.id, true),
    );
  }

  Stream<Pair<TransactionsFilterDate, ComplexTransactionsUIModel>> _transactionsStream() {
    return _dateStorage.currentDateStream
        .switchMap(
          (dateRange) => _transactionsAggregator
              .transactionsByDate(dateRange)
              .map((transactions) => Pair(dateRange, transactions)),
        )
        .map((pair) => Pair(
            pair.first, _transactionsHeaderUIMapper.mapTransactionsToUI(pair.second)));
  }
}
