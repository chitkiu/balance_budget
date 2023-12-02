import 'package:get/get.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/transformers.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/common/data/models/category.dart';
import '../../../categories/list/ui/categories_screen.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../../common/domain/number_validator.dart';
import '../../../common/ui/common_selection_list.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../../wallets/list/ui/wallets_screen.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../common/data/models/rich_transaction_model.dart';
import '../ui/models/date_selection_type.dart';
import '../ui/models/select_date_ui_model.dart';
import 'mappers/transaction_category_ui_mapper.dart';
import 'mappers/transaction_wallet_ui_mapper.dart';

class UpdateTransactionController extends GetxController with NumberValidator {
  final RichTransactionModel? model;

  UpdateTransactionController({this.model});

  final TransactionCategoryUIMapper _transactionCategoryUIMapper =
      TransactionCategoryUIMapper();
  final TransactionWalletUIMapper _transactionWalletUIMapper =
      TransactionWalletUIMapper();

  LocalTransactionsRepository get _transactionsRepo => Get.find();

  LocalCategoryRepository get _categoryRepo => Get.find();

  LocalWalletRepository get _walletRepo => Get.find();

  final Rxn<Category> _selectedCategory = Rxn();

  RxList<SelectionListItem<Category>> categoryList = RxList();

  final Rxn<String> _selectedWalletId = Rxn();
  final Rxn<String> _selectedToWalletId = Rxn();

  RxList<SelectionListItem<String>> selectedWallet = RxList();
  RxList<SelectionListItem<String>> selectedToWallet = RxList();

  Rx<SelectDayUIModel> selectedDate = SelectDayUIModel.now().obs;

  final selectedType = TransactionType.expense.obs;

  final categoryError = Rxn<String>();
  final fromWalletError = Rxn<String>();
  final toWalletError = Rxn<String>();

  @override
  void onReady() {
    //TODO Move to separate class

    ///TODO think about hiding archived items
    ///TODO We can have some problem with it if we try to edit transaction with archived category/wallet
    categoryList.bindStream(CombineLatestStream.combine2(
      selectedType.stream.switchMap(_categoryRepo.getCategoriesByType),
      _selectedCategory.stream,
      _transactionCategoryUIMapper.map,
    ));

    //Add refresh for set initial data
    _selectedCategory.refresh();
    selectedType.refresh();

    selectedWallet.bindStream(CombineLatestStream.combine2(
      _walletRepo.walletsWithoutArchived,
      _selectedWalletId.stream,
      _transactionWalletUIMapper.map,
    ));

    selectedToWallet.bindStream(CombineLatestStream.combine2(
      _walletRepo.walletsWithoutArchived,
      _selectedToWalletId.stream,
      _transactionWalletUIMapper.map,
    ));

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

    if (double.tryParse(sum) == null) {
      return;
    }

    final type = selectedType.value;

    var category = _selectedCategory.value;

    if (type != TransactionType.transfer) {
      if (category == null) {
        categoryError.value = "Please, select category!";
        return;
      }
      if (category.transactionType != type) {
        categoryError.value = "Please, select correct category or transaction type";
        return;
      }
    }

    var fromWalletId = _selectedWalletId.value;
    if (fromWalletId == null) {
      fromWalletError.value = "Please, select wallet!";
      return;
    }

    if (type == TransactionType.transfer) {
      var toWalletId = _selectedToWalletId.value;

      if (toWalletId == null) {
        toWalletError.value = "Please, select wallet!";
        return;
      }

      if (toWalletId == fromWalletId) {
        toWalletError.value = "Please, select different wallet as target!";
        return;
      }
    }

    DateTime selected = selectedDate.value.dateTime;

    var addTransactionResult = _transactionsRepo.createOrUpdate(
      double.parse(sum),
      type,
      fromWalletId,
      DateTime(
        selected.year,
        selected.month,
        selected.day,
      ),
      model: model,
      comment: currentComment,
      toWalletId: _selectedToWalletId.value,
      categoryId: category?.id,
    );

    if (addTransactionResult) {
      Get.back();
    }
  }

  void selectCategory(Category category) {
    final type = selectedType.value;
    if (type != category.transactionType) {
      categoryError.value = "Please, select correct category or transaction type";
      return;
    }
    if (_selectedCategory.value?.id == category.id) {
      _selectedCategory.value = null;
    } else {
      _selectedCategory.value = category;
    }
    categoryError.value = null;
  }

  void selectWallet(String walletId) {
    if (_selectedWalletId.value == walletId) {
      _selectedWalletId.value = null;
    } else {
      _selectedWalletId.value = walletId;
    }
    fromWalletError.value = null;
  }

  void selectToWallet(String walletId) {
    if (_selectedToWalletId.value == walletId) {
      _selectedToWalletId.value = null;
    } else {
      _selectedToWalletId.value = walletId;
    }
    toWalletError.value = null;
  }

  void selectType(TransactionType type) {
    if (type == TransactionType.transfer) {
      categoryError.value = null;
      _selectedCategory.value = null;
    } else {
      toWalletError.value = null;
      _selectedToWalletId.value = null;
    }

    selectedType.value = type;
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
      () => const CategoriesScreen(),
    );
  }

  void onManageWalletsClick() {
    Get.to(
      () => const WalletsScreen(),
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
      _selectedCategory.value = model.category;
    }
    selectedType.value = model.transaction.transactionType;
    _selectCustomDay(model.transaction.time);
    _selectedWalletId.value = model.fromWallet.id;
    if (model is TransferRichTransactionModel) {
      _selectedToWalletId.value = model.toWallet.id;
    }
  }
}
