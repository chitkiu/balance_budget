import 'dart:async';

import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rxd;

import '../../../accounts/common/data/local_account_repository.dart';
import '../../../accounts/list/domain/accounts_binding.dart';
import '../../../accounts/list/ui/accounts_screen.dart';
import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/list/domain/categories_binding.dart';
import '../../../categories/list/ui/categories_screen.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../common/data/local_transactions_repository.dart';
import '../ui/models/date_selection_type.dart';
import '../ui/models/select_date_ui_model.dart';
import '../ui/models/transaction_account_ui_model.dart';
import '../ui/models/transaction_category_ui_model.dart';
import 'mappers/transaction_account_ui_mapper.dart';
import 'mappers/transaction_category_ui_mapper.dart';

class AddTransactionController extends GetxController {
  final TransactionCategoryUIMapper _spendCategoryUIMapper =
      TransactionCategoryUIMapper();
  final TransactionAccountUIMapper _spendAccountUIMapper = TransactionAccountUIMapper();

  LocalTransactionsRepository get _transactionsRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalAccountRepository get _accountRepo => Get.find();

  RxList<TransactionCategoryUIModel> categoryList = <TransactionCategoryUIModel>[].obs;

  RxList<TransactionAccountUIModel> accountList = <TransactionAccountUIModel>[].obs;

  Rxn<String> selectedCategory = Rxn();

  Rxn<String> selectedAccount = Rxn();

  Rxn<String> selectedToAccount = Rxn();

  Rx<SelectDayUIModel> selectedDate = SelectDayUIModel.now().obs;

  var selectedType = TransactionType.spend.obs;

  StreamSubscription? _subscription;
  StreamSubscription? _accountSubscription;

  @override
  void onReady() {
    _subscription?.cancel();

    //TODO Move to separate class
    _subscription = rxd.CombineLatestStream.combine3(
      _categoryRepo.categories,
      selectedCategory.stream,
      selectedType.stream,
      _spendCategoryUIMapper.map,
    ).listen((value) {
      categoryList.value = value;
    });

    //Add refresh for set initial data
    selectedCategory.refresh();
    selectedType.refresh();

    _accountSubscription?.cancel();
    _accountSubscription = _accountRepo.accounts
        .map((event) => _spendAccountUIMapper.map(event))
        .listen((value) {
      accountList.value = value;
    });

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
    if (categoryId == null && selectedType.value != TransactionType.transfer) {
      return;
    }

    var accountId = selectedAccount.value;
    if (accountId == null) {
      return;
    }

    if (selectedType.value == TransactionType.transfer) {
      var toAccountId = selectedToAccount.value;

      if (toAccountId == null) {
        return;
      }

      if (toAccountId == accountId) {
        return;
      }
    }

    DateTime selected = selectedDate.value.dateTime;

    var addTransactionResult = _transactionsRepo.create(
      double.parse(sum),
      selectedType.value,
      accountId,
      DateTime(
        selected.year,
        selected.month,
        selected.day,
      ),
      comment: currentComment,
      toAccountId: selectedToAccount.value,
      categoryId: categoryId,
    );

    if (addTransactionResult) {
      Get.back();
    }
  }

  void selectCategory(TransactionCategoryUIModel category) {
    selectedCategory.value = category.categoryId;
  }

  void selectAccount(TransactionAccountUIModel account) {
    selectedAccount.value = account.accountId;
  }

  void selectToAccount(TransactionAccountUIModel account) {
    selectedToAccount.value = account.accountId;
  }

  void selectDateByType(
    DateSelectionType type,
    DateTime? date,
  ) {
    switch (type) {
      case DateSelectionType.yesterday:
        _selectYesterday();
        break;
      case DateSelectionType.today:
        _selectToday();
        break;
      case DateSelectionType.customDate:
        _selectCustomDay(date!);
        break;
    }
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

  void _selectYesterday() {
    selectedDate.value = SelectDayUIModel(
      DateTime.now().subtract(const Duration(days: 1)),
      isToday: false,
      isYesterday: true,
    );
  }

  void _selectToday() {
    selectedDate.value = SelectDayUIModel.now();
  }

  void _selectCustomDay(DateTime dateTime) {
    DateTime now = DateTime.now();
    selectedDate.value = SelectDayUIModel(
      dateTime,
      isToday: _isSameDate(now, dateTime),
      isYesterday: _isSameDate(now.subtract(const Duration(days: 1)), dateTime),
    );
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
