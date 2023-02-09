import 'dart:async';

import 'package:balance_budget/spends/add/ui/add_spend_screen.dart';
import 'package:balance_budget/spends/list/data/spend_aggregator.dart';
import 'package:get/get.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../add/domain/add_spend_binding.dart';
import '../../common/data/local_spend_repository.dart';
import '../ui/models/spend_ui_model.dart';
import 'mappers/spend_ui_mapper.dart';

class SpendsController extends GetxController {
  LocalSpendRepository get _spendRepo => Get.find();
  LocalCategoryRepository get _categoryRepo => Get.find();
  SpendAggregator get _spendAggregator => Get.find();

  final SpendUIMapper _spendUIMapper = const SpendUIMapper();
  RxList<SpendUIModel> spends = <SpendUIModel>[].obs;
  StreamSubscription? _spendListener;

  @override
  void onReady() {
    _spendListener?.cancel();
    _spendListener = _spendAggregator.spends().listen((event) {
      spends.value = event
          .map(_spendUIMapper.mapFromRich)
          .toList();
    });
    //Add refresh for set initial data
    _categoryRepo.categories.refresh();
    _spendRepo.spends.refresh();

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
