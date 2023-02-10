import 'dart:async';

import 'package:balance_budget/accounts/common/data/local_account_repository.dart';
import 'package:balance_budget/accounts/common/data/models/account_id.dart';
import 'package:balance_budget/spends/add/ui/models/spend_account_ui_model.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/add/domain/add_category_binding.dart';
import '../../../categories/add/ui/add_category_screen.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category_id.dart';
import '../../common/data/local_spend_repository.dart';
import '../ui/models/spend_category_ui_model.dart';
import 'mappers/spend_account_ui_mapper.dart';
import 'mappers/spend_category_ui_mapper.dart';

class AddSpendController extends GetxController {
  final SpendCategoryUIMapper _spendCategoryUIMapper = SpendCategoryUIMapper();
  final SpendAccountUIMapper _spendAccountUIMapper = SpendAccountUIMapper();

  LocalSpendRepository get _spendRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalAccountRepository get _accountRepo => Get.find();

  RxList<SpendCategoryUIModel> categoryList = <SpendCategoryUIModel>[].obs;

  RxList<SpendAccountUIModel> accountList = <SpendAccountUIModel>[].obs;

  Rxn<CategoryId> selectedCategory = Rxn();

  Rxn<AccountId> selectedAccount = Rxn();

  StreamSubscription? _subscription;
  StreamSubscription? _accountSubscription;

  @override
  void onReady() {
    _subscription?.cancel();

    //TODO Move to separate class
    _subscription = CombineLatestStream.combine2(
      _categoryRepo.categories.stream,
      selectedCategory.stream,
      _spendCategoryUIMapper.map,
    ).listen((value) {
      categoryList.value = value;
    });

    //Add refresh for set initial data
    _categoryRepo.categories.refresh();
    selectedCategory.refresh();

    _accountSubscription?.cancel();
    _accountSubscription = CombineLatestStream.combine2(
      _accountRepo.accounts.stream,
      selectedAccount.stream,
      _spendAccountUIMapper.map,
    ).listen((value) {
      accountList.value = value;
    });

    _accountRepo.accounts.refresh();
    selectedAccount.refresh();

    super.onReady();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _subscription = null;
    _accountSubscription?.cancel();
    _accountSubscription = null;
    super.onClose();
  }

  void onSaveSpend(String sum, String comment) {
    String? currentComment = comment;
    if (comment.isEmpty) {
      currentComment = null;
    }

    //TODO Add error
    if (double.tryParse(sum) == null) {
      return;
    }

    var categoryId = selectedCategory.value;
    if (categoryId == null) {
      return;
    }

    var accountId = selectedAccount.value;
    if (accountId == null) {
      return;
    }

    _spendRepo.create(
        double.parse(sum),
        categoryId,
        accountId,
        DateTime.now(),
        currentComment
    );

    Get.back();
  }

  void selectCategory(SpendCategoryUIModel category) {
    selectedCategory.value = category.categoryId;
  }

  void selectAccount(SpendAccountUIModel account) {
    selectedAccount.value = account.accountId;
  }

  void onAddCategoryClick() {
    Get.to(
      () => AddCategoryScreen(),
      binding: AddCategoryBinding(),
    );
  }
}
