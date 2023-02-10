import 'dart:async';

import 'package:get/get.dart';

import '../../../accounts/common/data/local_account_repository.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../add/domain/add_spend_binding.dart';
import '../../add/ui/add_spend_screen.dart';
import '../../common/data/local_spend_repository.dart';
import '../data/spend_aggregator.dart';
import '../ui/models/grouped_spend_ui_model.dart';
import 'mappers/spend_ui_mapper.dart';

class SpendsController extends GetxController {
  LocalSpendRepository get _spendRepo => Get.find();
  LocalCategoryRepository get _categoryRepo => Get.find();
  LocalAccountRepository get _accountRepo => Get.find();
  SpendAggregator get _spendAggregator => Get.find();

  final SpendUIMapper _spendUIMapper = SpendUIMapper();
  RxList<GroupedSpendUIModel> spends = <GroupedSpendUIModel>[].obs;
  StreamSubscription? _spendListener;

  @override
  void onReady() {
    _spendListener?.cancel();
    _spendListener = _spendAggregator.spends().listen((event) {
      spends.value = _spendUIMapper.mapGroup(event);
    });
    //Add refresh for set initial data
    _categoryRepo.categories.refresh();
    _spendRepo.spends.refresh();
    _accountRepo.accounts.refresh();

    super.onReady();
  }

  @override
  void onClose() {
    _spendListener?.cancel();
    _spendListener = null;
    super.onClose();
  }

  void addSpend() {
    Get.to(
      () => AddSpendScreen(),
      binding: AddSpendBinding()
    );
  }

}
