import 'package:get/get.dart';

import '../../common/data/local_transactions_repository.dart';
import '../../list/data/transactions_aggregator.dart';
import '../../list/domain/mappers/transactions_ui_mapper.dart';
import '../../list/ui/models/transaction_ui_model.dart';

class TransactionInfoController extends GetxController {
  LocalTransactionsRepository get _transactionsRepo => Get.find();
  TransactionsAggregator get _transactionsAggregator => Get.find();

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();

  Stream<TransactionUIModel?> transactionById(String id) {
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

  Future<void> editTransaction(
    String id, {
    required String newSum,
    required String newComment,
  }) async {
    var newDoubleSum = double.tryParse(newSum);

    await _transactionsRepo.edit(
      id,
      sum: newDoubleSum,
      comment: newComment.trim(),
    );
  }
}
