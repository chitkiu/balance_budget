import 'dart:async';

import 'package:balance_budget/categories/common/data/local_category_repository.dart';
import 'package:balance_budget/categories/list/domain/mappers/category_ui_mapper.dart';
import 'package:balance_budget/common/ui/transaction_item/models/transaction_ui_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rxdart/transformers.dart';

import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/transaction_item/mappers/transactions_header_ui_mapper.dart';
import '../../../common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import '../../../transactions/common/data/models/rich_transaction_model.dart';
import '../../../transactions/common/data/rich_transaction_comparator.dart';
import '../../../transactions/info/domain/transaction_info_controller.dart';
import '../../../transactions/info/ui/transaction_info_screen.dart';
import '../../../transactions/list/data/transactions_aggregator.dart';
import '../../common/data/models/category.dart';
import '../ui/models/rich_category_ui_model.dart';

class CategoryInfoController extends GetxController
    with StateMixin<RichCategoryUIModel> {
  final String id;

  CategoryInfoController(this.id);

  LocalCategoryRepository get _categoryRepo => Get.find();
  TransactionsAggregator get _transactionsAggregator => Get.find();

  final _categoryUIMapper = const CategoryUIMapper();

  final TransactionsHeaderUIMapper _transactionsHeaderUIMapper =
      TransactionsHeaderUIMapper(
    const RichTransactionComparator(),
    TransactionsUIMapper(),
  );

  StreamSubscription? _categorySubscription;

  @override
  void onInit() {
    super.onInit();

    _categorySubscription ??= _categoryRepo.getCategoryById(id).switchMap((category) {
      if (category == null) {
        return const Stream.empty();
      } else {
        return _transactionsAggregator
            .transactionByCategoryId(category.id)
            .map((transactions) => _mapToUIModel(category, transactions));
      }
    }).handleError((Object e, StackTrace str) {
      change(null, status: RxStatus.error(str.toString()));
    }).listen((event) {
      if (event is RichCategoryUIModel) {
        change(event, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    });
  }

  @override
  void onClose() {
    super.onClose();

    _categorySubscription?.cancel();
    _categorySubscription = null;
  }

  void onTransactionClicked(BuildContext context, TransactionUIModel transaction) {
    openModalSheetWithController(
      context,
          (controller) {
        return TransactionInfoScreen(controller: controller,);
      },
      TransactionInfoController(transaction.id),
    );
  }

  RichCategoryUIModel _mapToUIModel(
      Category category, List<RichTransactionModel> transactions) {
    return RichCategoryUIModel(
        _categoryUIMapper.map(category),
        _transactionsHeaderUIMapper.mapTransactionsToUI(transactions));
  }
}