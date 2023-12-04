import 'dart:async';

import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../common/pair.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/transaction_item/mappers/transactions_ui_mapper.dart';
import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/rich_transaction_model.dart';
import '../../list/data/transactions_aggregator.dart';
import '../../update/domain/update_transaction_controller.dart';
import '../../update/ui/update_transaction_screen.dart';
import 'transaction_info_state.dart';

class TransactionInfoCubit extends Cubit<TransactionInfoState> {
  final LocalTransactionsRepository _transactionsRepo;
  final String id;
  final TransactionsAggregator _transactionsAggregator;
  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();

  StreamSubscription? _transactionSubscription;

  TransactionInfoCubit(this.id, this._transactionsRepo, this._transactionsAggregator)
      : super(TransactionInfoState(null, null, false)) {
    _transactionSubscription ??= _transactionById().listen((event) {
      emit(
          TransactionInfoState(
              event?.first,
              event?.second,
              (event?.first != null) ? _canEditTransaction(event!.first) : false
          )
      );
    });
  }


  @override
  Future<void> close() async {
    await _transactionSubscription?.cancel();
    _transactionSubscription = null;
    await super.close();
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionsRepo.remove(id);
  }

  void goToEdit(BuildContext context) {
    final dataModel = state.dataModel;
    if (dataModel == null || !_canEditTransaction(dataModel)) {
      return;
    }

    openModalSheetWithController(
      context,
          (controller) {
        return UpdateTransactionScreen(
          title: Get.localisation.addTransactionTitle,
          controller: controller,
          model: dataModel,
        );
      },
      UpdateTransactionController(model: dataModel),
    );
  }

  bool _canEditTransaction(RichTransactionModel model) {
    if (model is InitialBalanceRichTransactionModel) {
      return !model.fromWallet.archived;
    }
    if (model is CategoryRichTransactionModel) {
      return !model.category.archived && !model.fromWallet.archived;
    }
    if (model is TransferRichTransactionModel) {
      return (!model.fromWallet.archived || !model.toWallet.archived);
    }
    return false;
  }

  Stream<Pair<RichTransactionModel, TransactionUIModel?>?> _transactionById() {
    return _transactionsAggregator.transactionById(id).map((event) {
      if (event == null) {
        return null;
      } else {
        return Pair(event, _transactionsUIMapper.mapFromRich(event));
      }
    });
  }
}
