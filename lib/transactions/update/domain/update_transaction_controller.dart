import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rxd;

import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/list/domain/categories_binding.dart';
import '../../../categories/list/ui/categories_screen.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../../common/ui/common_selection_list.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../../wallets/list/domain/wallets_binding.dart';
import '../../../wallets/list/ui/wallets_screen.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/rich_transaction_model.dart';
import '../ui/models/date_selection_type.dart';
import '../ui/models/select_date_ui_model.dart';
import 'mappers/transaction_category_ui_mapper.dart';
import 'mappers/transaction_wallet_ui_mapper.dart';

class UpdateTransactionController extends GetxController {
  final RichTransactionModel? model;

  UpdateTransactionController({this.model});

  final TransactionCategoryUIMapper _transactionCategoryUIMapper =
      TransactionCategoryUIMapper();
  final TransactionWalletUIMapper _transactionWalletUIMapper =
      TransactionWalletUIMapper();

  LocalTransactionsRepository get _transactionsRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalWalletRepository get _walletRepo => Get.find();

  Rxn<String> _selectedCategory = Rxn();

  RxList<SelectionListItem<String>> categoryList = RxList();

  Rxn<String> _selectedWalletId = Rxn();
  Rxn<String> _selectedToWalletId = Rxn();

  RxList<SelectionListItem<String>> selectedWallet = RxList();
  RxList<SelectionListItem<String>> selectedToWallet = RxList();

  Rx<SelectDayUIModel> selectedDate = SelectDayUIModel.now().obs;

  final selectedType = TransactionType.expense.obs;

  @override
  void onReady() {
    //TODO Move to separate class
    categoryList.bindStream(rxd.CombineLatestStream.combine3(
      _categoryRepo.categories,
      _selectedCategory.stream,
      selectedType.stream,
      _transactionCategoryUIMapper.map,
    ));

    //Add refresh for set initial data
    _selectedCategory.refresh();
    selectedType.refresh();

    selectedWallet.bindStream(
      rxd.CombineLatestStream.combine2(
          _walletRepo.wallets,
          _selectedWalletId.stream,
          _transactionWalletUIMapper.map,
      )
    );

    selectedToWallet.bindStream(
      rxd.CombineLatestStream.combine2(
          _walletRepo.wallets,
          _selectedToWalletId.stream,
          _transactionWalletUIMapper.map,
      )
    );

    _selectedWalletId.refresh();
    _selectedToWalletId.refresh();

    if (model != null) {
      _setupInitialData(model!);
    }

    super.onReady();
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

    var categoryId = _selectedCategory.value;
    if (categoryId == null && selectedType.value != TransactionType.transfer) {
      return;
    }

    var walletId = _selectedWalletId.value;
    if (walletId == null) {
      return;
    }

    if (selectedType.value == TransactionType.transfer) {
      var toWalletId = _selectedToWalletId.value;

      if (toWalletId == null) {
        return;
      }

      if (toWalletId == walletId) {
        return;
      }
    }

    DateTime selected = selectedDate.value.dateTime;

    var addTransactionResult = _transactionsRepo.createOrUpdate(
      double.parse(sum),
      selectedType.value,
      walletId,
      DateTime(
        selected.year,
        selected.month,
        selected.day,
      ),
      model: model,
      comment: currentComment,
      toWalletId: _selectedToWalletId.value,
      categoryId: categoryId,
    );

    if (addTransactionResult) {
      Get.back();
    }
  }

  void selectCategory(String categoryId) {
    if (_selectedCategory.value == categoryId) {
      _selectedCategory.value = null;
    } else {
      _selectedCategory.value = categoryId;
    }
  }

  void selectWallet(String walletId) {
    if (_selectedWalletId.value == walletId) {
      _selectedWalletId.value = null;
    } else {
      _selectedWalletId.value = walletId;
    }
  }

  void selectToWallet(String walletId) {
    if (_selectedToWalletId.value == walletId) {
      _selectedToWalletId.value = null;
    } else {
      _selectedToWalletId.value = walletId;
    }
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

  void _setupInitialData(RichTransactionModel model) {
    if (model is CategoryRichTransactionModel) {
      _selectedCategory.value = model.category.id;
    }
    selectedType.value = model.transaction.transactionType;
    _selectCustomDay(model.transaction.time);
    _selectedWalletId.value = model.fromWallet.id;
    if (model is TransferRichTransactionModel) {
      _selectedToWalletId.value = model.toWallet.id;
    }
  }
}
