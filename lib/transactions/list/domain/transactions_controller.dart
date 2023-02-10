import 'dart:async';

import 'package:get/get.dart';

import '../../../accounts/common/data/local_account_repository.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../add/domain/add_transaction_binding.dart';
import '../../add/ui/add_transaction_screen.dart';
import '../../common/data/local_transactions_repository.dart';
import '../data/transactions_aggregator.dart';
import '../ui/models/grouped_transactions_ui_model.dart';
import 'mappers/transactions_ui_mapper.dart';

class TransactionsController extends GetxController {
  LocalTransactionsRepository get _transactionsRepo => Get.find();
  LocalCategoryRepository get _categoryRepo => Get.find();
  LocalAccountRepository get _accountRepo => Get.find();
  TransactionsAggregator get _transactionsAggregator => Get.find();

  final TransactionsUIMapper _transactionsUIMapper = TransactionsUIMapper();
  RxList<GroupedTransactionsUIModel> transactions = <GroupedTransactionsUIModel>[].obs;
  StreamSubscription? _spendListener;

  @override
  void onReady() {
    _spendListener?.cancel();
    _spendListener = _transactionsAggregator.spends().listen((event) {
      transactions.value = _transactionsUIMapper.mapGroup(event);
    });
    //Add refresh for set initial data
    _categoryRepo.categories.refresh();
    _transactionsRepo.transactions.refresh();
    _accountRepo.accounts.refresh();

    super.onReady();
  }

  @override
  void onClose() {
    _spendListener?.cancel();
    _spendListener = null;
    super.onClose();
  }

  void addTransaction() {
    Get.to(
      () => AddTransactionScreen(),
      binding: AddTransactionBinding()
    );
  }

}
