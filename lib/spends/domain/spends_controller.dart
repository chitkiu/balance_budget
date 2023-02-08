import 'dart:async';

import 'package:balance_budget/spends/data/spend_aggregator.dart';
import 'package:get/get.dart';

import '../../categories/data/local_category_repository.dart';
import '../data/local_spend_repository.dart';
import '../ui/models/spend_ui_model.dart';
import 'mappers/spend_ui_mapper.dart';

class SpendsController extends GetxController {
  LocalSpendRepository get _spendRepo => Get.find();
  LocalCategoryRepository get _categoryRepo => Get.find();
  late final SpendAggregator _spendAggregator;

  final SpendUIMapper _spendUIMapper = const SpendUIMapper();
  RxList<SpendUIModel> spends = <SpendUIModel>[].obs;
  StreamSubscription? _spendListener;

  @override
  void onInit() async {
    _spendAggregator = SpendAggregator();

    super.onInit();
  }

  @override
  void onReady() {
    _spendListener?.cancel();
    _spendListener = _spendAggregator.spends().listen((event) {
      spends.value = event
          .map(_spendUIMapper.mapFromRich)
          .toList();
    });
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
    _spendRepo.create(
        1.2, _categoryRepo.categories[0].id, DateTime.now(), null);
  }

}
