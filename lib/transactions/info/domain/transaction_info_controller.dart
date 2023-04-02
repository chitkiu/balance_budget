import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../list/data/models/rich_transaction_model.dart';
import '../../list/data/transactions_aggregator.dart';
import '../../list/domain/mappers/transactions_ui_mapper.dart';
import '../../list/ui/models/transaction_ui_model.dart';
import '../../update/domain/update_transaction_binding.dart';
import '../../update/ui/update_transaction_screen.dart';

class TransactionInfoController extends GetxController {
  final String id;

  TransactionInfoController(this.id);

  LocalTransactionsRepository get _transactionsRepo => Get.find();
  TransactionsAggregator get _transactionsAggregator => Get.find();

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();

  final Rxn<RichTransactionModel> _dataTransactionModel = Rxn();
  final Rxn<TransactionUIModel> transaction = Rxn();

  @override
  void onInit() {
    _dataTransactionModel.bindStream(_transactionsAggregator.transactionById(id));
    transaction.bindStream(_transactionById(id));

    super.onInit();
  }

  Stream<TransactionUIModel?> _transactionById(String id) {
    return _transactionsAggregator.transactionById(id).map((event) {
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

  void goToEdit() {
    UpdateTransactionScreen(
      title: Get.localisation.transactionInfoEditTitle,
      bindingCreator: () => UpdateTransactionBinding(model: _dataTransactionModel.value),
      model: _dataTransactionModel.value,
    ).open();
  }
}
