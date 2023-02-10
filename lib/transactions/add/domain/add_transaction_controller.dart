import 'dart:async';

import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../accounts/common/data/local_account_repository.dart';
import '../../../accounts/common/data/models/account_id.dart';
import '../../../accounts/list/domain/accounts_binding.dart';
import '../../../accounts/list/ui/accounts_screen.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category_id.dart';
import '../../../categories/list/domain/categories_binding.dart';
import '../../../categories/list/ui/categories_screen.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../common/data/local_transactions_repository.dart';
import '../ui/models/transaction_account_ui_model.dart';
import '../ui/models/transaction_category_ui_model.dart';
import 'mappers/transaction_account_ui_mapper.dart';
import 'mappers/transaction_category_ui_mapper.dart';

class AddTransactionController extends GetxController {
  final TransactionCategoryUIMapper _spendCategoryUIMapper = TransactionCategoryUIMapper();
  final TransactionAccountUIMapper _spendAccountUIMapper = TransactionAccountUIMapper();

  LocalTransactionsRepository get _spendRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalAccountRepository get _accountRepo => Get.find();

  RxList<TransactionCategoryUIModel> categoryList = <TransactionCategoryUIModel>[].obs;

  RxList<TransactionAccountUIModel> accountList = <TransactionAccountUIModel>[].obs;

  Rxn<CategoryId> selectedCategory = Rxn();

  Rxn<AccountId> selectedAccount = Rxn();

  var selectedType = TransactionType.spend.obs;

  StreamSubscription? _subscription;
  StreamSubscription? _accountSubscription;

  @override
  void onReady() {
    _subscription?.cancel();

    //TODO Move to separate class
    _subscription = CombineLatestStream.combine3(
      _categoryRepo.categories.stream,
      selectedCategory.stream,
      selectedType.stream,
      _spendCategoryUIMapper.map,
    ).listen((value) {
      categoryList.value = value;
    });

    //Add refresh for set initial data
    _categoryRepo.categories.refresh();
    selectedCategory.refresh();
    selectedType.refresh();

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

  void onSaveTransaction(String sum, String comment) {
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
        selectedType.value,
        categoryId,
        accountId,
        DateTime.now(),
        currentComment
    );

    Get.back();
  }

  void selectCategory(TransactionCategoryUIModel category) {
    selectedCategory.value = category.categoryId;
  }

  void selectAccount(TransactionAccountUIModel account) {
    selectedAccount.value = account.accountId;
  }

  void onManageCategoriesClick() {
    Get.to(
      () => CategoriesScreen(),
      binding: CategoriesBinding(),
    );
  }

  void onManageAccountsClick() {
    Get.to(
      () => AccountsScreen(),
      binding: AccountsBinding(),
    );
  }
}
