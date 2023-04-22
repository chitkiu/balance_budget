import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/rich_transaction_model.dart';
import '../../list/data/transactions_aggregator.dart';
import '../../update/domain/update_transaction_controller.dart';
import '../../update/ui/update_transaction_screen.dart';

class TransactionInfoController extends GetxController {
  final String id;
  final bool canEdit;

  TransactionInfoController(this.id, this.canEdit);

  LocalTransactionsRepository get _transactionsRepo => Get.find();
  TransactionsAggregator get _transactionsAggregator => Get.find();

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();

  final Rxn<RichTransactionModel> _dataTransactionModel = Rxn();
  final Rxn<TransactionUIModel> transaction = Rxn();

  @override
  void onInit() {
    transaction.bindStream(_transactionById());
    _dataTransactionModel
        .bindStream(_transactionsAggregator.transactionById(id));

    super.onInit();
  }

  Stream<TransactionUIModel?> _transactionById() {
    return _dataTransactionModel.stream.map((event) {
      if (event == null) {
        return null;
      } else {
        return _transactionsUIMapper.mapFromRich(event);
      }
    });
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionsRepo.remove(id);
  }

  void goToEdit(BuildContext context) {
    if (!canEdit) return;
    openModalSheetWithController(
      context,
      (controller) {
        return UpdateTransactionScreen(
          title: Get.localisation.addTransactionTitle,
          controller: controller,
          model: _dataTransactionModel.value,
        );
      },
      UpdateTransactionController(model: _dataTransactionModel.value),
    );
  }
}
