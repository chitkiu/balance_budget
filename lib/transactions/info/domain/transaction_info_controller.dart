import 'package:get/get.dart';

import '../../common/data/local_transactions_repository.dart';

class TransactionInfoController extends GetxController {
  LocalTransactionsRepository get _transactionsRepo => Get.find();

  Future<void> deleteTransaction(String id) async {
    await _transactionsRepo.remove(id);
  }
}