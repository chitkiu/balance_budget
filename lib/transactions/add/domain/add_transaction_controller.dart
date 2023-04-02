import 'dart:async';

import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rxd;

import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/list/domain/categories_binding.dart';
import '../../../categories/list/ui/categories_screen.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../../wallets/list/domain/wallets_binding.dart';
import '../../../wallets/list/ui/wallets_screen.dart';
import '../../common/data/local_transactions_repository.dart';
import '../ui/models/date_selection_type.dart';
import '../ui/models/select_date_ui_model.dart';
import '../ui/models/transaction_category_ui_model.dart';
import '../ui/models/transaction_wallet_ui_model.dart';
import 'mappers/transaction_category_ui_mapper.dart';
import 'mappers/transaction_wallet_ui_mapper.dart';

class AddTransactionController extends GetxController {
  final TransactionCategoryUIMapper _expenseCategoryUIMapper =
      TransactionCategoryUIMapper();
  final TransactionWalletUIMapper _expenseWalletUIMapper = TransactionWalletUIMapper();

  LocalTransactionsRepository get _transactionsRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalWalletRepository get _walletRepo => Get.find();

  RxList<TransactionCategoryUIModel> categoryList = <TransactionCategoryUIModel>[].obs;

  RxList<TransactionWalletUIModel> walletList = <TransactionWalletUIModel>[].obs;

  Rxn<String> selectedCategory = Rxn();

  Rxn<String> selectedWallet = Rxn();

  Rxn<String> selectedToWallet = Rxn();

  Rx<SelectDayUIModel> selectedDate = SelectDayUIModel.now().obs;

  var selectedType = TransactionType.expense.obs;

  StreamSubscription? _subscription;

  @override
  void onReady() {
    _subscription?.cancel();

    //TODO Move to separate class
    _subscription = rxd.CombineLatestStream.combine3(
      _categoryRepo.categories,
      selectedCategory.stream,
      selectedType.stream,
      _expenseCategoryUIMapper.map,
    ).listen((value) {
      categoryList.value = value;
    });

    //Add refresh for set initial data
    selectedCategory.refresh();
    selectedType.refresh();

    walletList.bindStream(_walletRepo.wallets
        .map((event) => _expenseWalletUIMapper.map(event)));

    selectedWallet.refresh();

    super.onReady();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _subscription = null;
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

    var walletId = selectedWallet.value;
    if (walletId == null) {
      return;
    }

    if (selectedType.value == TransactionType.transfer) {
      var toWalletId = selectedToWallet.value;

      if (toWalletId == null) {
        return;
      }

      if (toWalletId == walletId) {
        return;
      }
    }

    DateTime selected = selectedDate.value.dateTime;

    var addTransactionResult = _transactionsRepo.create(
      double.parse(sum),
      selectedType.value,
      walletId,
      DateTime(
        selected.year,
        selected.month,
        selected.day,
      ),
      comment: currentComment,
      toWalletId: selectedToWallet.value,
      categoryId: categoryId,
    );

    if (addTransactionResult) {
      Get.back();
    }
  }

  void selectCategory(TransactionCategoryUIModel category) {
    selectedCategory.value = category.categoryId;
  }

  void selectWallet(TransactionWalletUIModel wallet) {
    selectedWallet.value = wallet.walletId;
  }

  void selectToWallet(TransactionWalletUIModel wallet) {
    selectedToWallet.value = wallet.walletId;
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

  void onManageWalletsClick() {
    Get.to(
      () => WalletsScreen(),
      binding: WalletsBinding(),
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
