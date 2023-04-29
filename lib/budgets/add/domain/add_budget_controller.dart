import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../categories/common/data/local_category_repository.dart';
import '../../../categories/list/domain/mappers/category_ui_mapper.dart';
import '../../../categories/list/ui/models/category_ui_model.dart';
import '../../../common/data/models/transaction_type.dart';
import '../../../common/ui/common_selection_list.dart';
import '../../../wallets/common/data/local_wallet_repository.dart';
import '../../../wallets/list/domain/mappers/wallet_ui_mapper.dart';
import '../../../wallets/list/ui/models/wallet_ui_model.dart';
import '../../common/data/local_budget_repository.dart';
import '../../common/data/models/budget_repeat_type.dart';
import '../../common/data/models/budget_type.dart';
import '../../common/data/models/category_budget_info.dart';

class MultiCategoryBudgetUIModel {
  final List<WalletUIModel> wallets;
  final CategoryUIModel? category;
  final String amount;
  final bool isAllWalletSelected;

  MultiCategoryBudgetUIModel(this.wallets, this.category, this.amount, this.isAllWalletSelected);

  MultiCategoryBudgetUIModel copyWith({
    List<WalletUIModel>? wallets,
    CategoryUIModel? category,
    bool canCategoryBeNull = false,
    String? amount,
    bool? isAllWalletSelected,
  }) {
    return MultiCategoryBudgetUIModel(
      wallets ?? this.wallets,
      canCategoryBeNull ? category : category ?? this.category,
      amount ?? this.amount,
      isAllWalletSelected ?? this.isAllWalletSelected,
    );
  }
}

class AddBudgetController extends GetxController {
  LocalCategoryRepository get _categoryRepo => Get.find();
  LocalWalletRepository get _walletRepo => Get.find();
  LocalBudgetRepository get _budgetRepo => Get.find();

  final _categoryUIMapper = const CategoryUIMapper();
  final _walletUIMapper = const WalletUIMapper();

  final budgetType = BudgetType.total.obs;

  final categories = RxList<SelectionListItem<CategoryUIModel>>();
  final _selectedCategory = Rxn<CategoryUIModel>();

  final wallets = RxList<SelectionListItem<WalletUIModel>>();
  final _selectedWallets = RxList<WalletUIModel>();

  final multiCategories = RxList<MultiCategoryBudgetUIModel>();

  @override
  void onReady() {
    super.onReady();

    categories.bindStream(CombineLatestStream.combine2(
      _categoryRepo.getCategoriesByType(TransactionType.expense),
      _selectedCategory.stream,
      (categories, selectedCategory) {
        return categories.map((category) {
          final model = _categoryUIMapper.map(category);
          return SelectionListItem(
              model: model,
              name: model.name,
              isSelected: selectedCategory?.id == model.id
          );
        }).toList();
      },
    ));

    wallets.bindStream(CombineLatestStream.combine2(
        _walletRepo.walletsWithoutArchived, _selectedWallets.stream, (wallets, selectedWallet) {
      return wallets.map((e) {
        final wallet = _walletUIMapper.map(e, 0.0);
        return SelectionListItem(
          model: wallet,
          name: wallet.name,
          isSelected: selectedWallet.any((element) => element.id == e.id)
        );
      }).toList();
    }));

    _selectedWallets.refresh();
    _selectedCategory.refresh();
  }

  void selectWallet(WalletUIModel wallet) {
    if (_selectedWallets.any((element) => element.id == wallet.id)) {
      _selectedWallets.removeWhere((element) => element.id == wallet.id);
    } else {
      _selectedWallets.add(wallet);
    }
  }

  void selectCategory(CategoryUIModel category) {
    if (_selectedCategory.value?.id != category.id) {
      _selectedCategory.value = category;
    } else {
      _selectedCategory.value = null;
    }
  }

  void addMultiCategory() {
    multiCategories.add(MultiCategoryBudgetUIModel([], null, "", true));
  }

  void changeCategoryInMultiCategory(int index, CategoryUIModel model) {
    final oldItem = multiCategories.removeAt(index);
    CategoryUIModel? category = model;
    if (oldItem.category?.id == model.id) {
      category = null;
    }
    multiCategories.insert(
        index, oldItem.copyWith(canCategoryBeNull: true, category: category));
  }

  void changeWalletSelectionInMultiCategory(int index, bool isAllWalletSelected) {
    final oldItem = multiCategories.removeAt(index);
    multiCategories.insert(index, oldItem.copyWith(isAllWalletSelected: isAllWalletSelected));
  }

  void changeWalletInMultiCategory(int index, WalletUIModel wallet) {
    final oldItem = multiCategories.removeAt(index);
    final wallets = oldItem.wallets;
    if (wallets.any((element) => element.id == wallet.id)) {
      wallets.removeWhere((element) => element.id == wallet.id);
    } else {
      wallets.add(wallet);
    }
    multiCategories.insert(index, oldItem.copyWith(wallets: wallets,));
  }

  void removeMultiCategory(int index) {
    multiCategories.removeAt(index);
  }

  void changeAmountInMultiCategory(int index, String? amount) {
    final oldItem = multiCategories.removeAt(index);

    multiCategories.insert(index, oldItem.copyWith(amount: amount ?? ""));
  }

  void changeSelectedBudgetType(BudgetType budgetType) {
    this.budgetType.value = budgetType;
  }

  void saveBudget(String? name, String? amount) {
    bool result;
    switch (budgetType.value) {
      case BudgetType.category:
        result = _saveCategoryBudget(
          name ?? BudgetType.category.name,
          amount ?? "",
        );
        break;
      case BudgetType.total:
        result = _saveTotalBudget(
          name ?? BudgetType.total.name,
          amount ?? "",
        );
        break;
      case BudgetType.multiCategory:
        result = _saveMultiCategoryBudget(name ?? BudgetType.multiCategory.name);
        break;
    }

    if (result) {
      Get.back();
    }
  }

  bool _saveCategoryBudget(String name, String amount) {
    final doubleAmount = double.tryParse(amount ?? "");
    if (doubleAmount == null) {
      return false;
    }

    final categoryId = _selectedCategory.value?.id;

    if (categoryId == null) {
      return false;
    }

    _budgetRepo.createCategoryBudget(
      BudgetRepeatType.monthly,
      name,
      doubleAmount,
      categoryId,
      wallets: _selectedWallets.map((element) => element.id).toList(),
    );

    return true;
  }

  bool _saveTotalBudget(String name, String amount) {
    final doubleAmount = double.tryParse(amount ?? "");
    if (doubleAmount == null) {
      return false;
    }

    _budgetRepo.createTotalBudget(
      BudgetRepeatType.monthly,
      name,
      doubleAmount,
      wallets: _selectedWallets.map((element) => element.id).toList(),
    );

    return true;
  }

  bool _saveMultiCategoryBudget(String name) {
    final categories = multiCategories.value;
    if (categories.isNotEmpty) {
      final mappedCategories = categories.map((element) {
        if (element.category == null) {
          return null;
        }
        List<WalletUIModel> wallets = [];
        if (element.wallets.isEmpty) {
          if (!element.isAllWalletSelected) {
            return null;
          }
        } else {
          if (!element.isAllWalletSelected) {
            wallets = element.wallets;
          }
        }

        final doubleAmount = double.tryParse(element.amount ?? "");
        if (doubleAmount == null) {
          return null;
        }

        return CategoryBudgetInfo(
          categoryId: element.category!.id,
          maxSum: doubleAmount,
          wallets: wallets.map((e) => e.id).toList(),
        );
      })
          .whereNotNull()
          .toList();

      if (mappedCategories.isNotEmpty && categories.length == mappedCategories.length) {
        _budgetRepo.createMultiCategoryBudget(
          BudgetRepeatType.monthly, //TODO
          name,
          mappedCategories,
        );
        return true;
      }
    }
    return false;
  }
}
