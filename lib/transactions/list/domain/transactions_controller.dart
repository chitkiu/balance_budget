import 'dart:async';

import 'package:balance_budget/transactions/common/data/rich_transaction_comparator.dart';
import 'package:balance_budget/transactions/update/domain/update_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/transformers.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/transaction_item/mappers/transactions_header_ui_mapper.dart';
import '../../../common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import '../../../common/ui/transaction_item/models/complex_transactions_ui_model.dart';
import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';
import '../../info/domain/transaction_info_controller.dart';
import '../../info/ui/transaction_info_screen.dart';
import '../../update/ui/update_transaction_screen.dart';
import '../data/transactions_aggregator.dart';
import 'models/transactions_filter_date.dart';
import 'selected_transactions_date_storage.dart';

class TransactionsController extends GetxController
    with StateMixin<ComplexTransactionsUIModel> {
  TransactionsAggregator get _transactionsAggregator => Get.find();

  SelectedTransactionsDateStorage get _dateStorage => Get.find();

  late final Rx<TransactionsFilterDate> currentDate;

  final TransactionsHeaderUIMapper _transactionsHeaderUIMapper =
      TransactionsHeaderUIMapper(
    const RichTransactionComparator(),
    TransactionsUIMapper(),
  );

  StreamSubscription? _transactionsSubscription;

  @override
  void onInit() {
    super.onInit();

    currentDate = _dateStorage.currentDateStream.value.obs;

    currentDate.bindStream(_dateStorage.currentDateStream);

    _transactionsSubscription ??= _transactionsStream().listen((event) {
      if (event.transactions.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(event, status: RxStatus.success());
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    _transactionsSubscription?.cancel();
    _transactionsSubscription = null;
  }

  Stream<ComplexTransactionsUIModel> _transactionsStream() {
    return _dateStorage.currentDateStream.switchMap((dateRange) {
      return _transactionsAggregator
          .transactionsByDate(dateRange.start, dateRange.end, skipArchive: true)
          .map(_transactionsHeaderUIMapper.mapTransactionsToUI);
    }).handleError((Object e, StackTrace str) {
      change(null, status: RxStatus.error(str.toString()));
    });
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
        return TransactionInfoScreen(controller: controller,);
      },
      TransactionInfoController(transaction.id),
    );
  }

  void setNewDate(TransactionsFilterDate date) {
    _dateStorage.setNewDate(date);
  }
}
