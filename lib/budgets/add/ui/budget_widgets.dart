import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../categories/list/ui/models/category_ui_model.dart';
import '../../../common/ui/common_edit_text.dart';
import '../../../common/ui/common_selection_list.dart';
import '../../../wallets/list/ui/models/wallet_ui_model.dart';
import '../domain/add_budget_controller.dart';

class CommonBudgetWidget extends StatelessWidget {
  final bool showCategory;
  final TextEditingController? amountController;
  final Function(String)? changeAmount;
  final Iterable<SelectionListItem<WalletUIModel>> wallets;
  final Function(WalletUIModel) selectWallet;
  final Iterable<SelectionListItem<CategoryUIModel>> categories;
  final Function(CategoryUIModel) selectCategory;

  const CommonBudgetWidget(
      {Key? key,
      this.amountController,
      this.changeAmount,
      required this.wallets,
      required this.selectWallet,
      required this.categories,
      required this.selectCategory,
      required this.showCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Select wallet, or keep empty for all wallets"),
        CommonSelectionList<WalletUIModel>(
          items: wallets,
          onClick: selectWallet,
        ),
        const SizedBox(
          height: 8,
        ),
        if (showCategory) Text("Select category"),
        if (showCategory)
          CommonSelectionList<CategoryUIModel>(
            items: categories,
            onClick: selectCategory,
          ),
        if (showCategory)
          const SizedBox(
            height: 8,
          ),
        CommonEditText(
          controller: amountController,
          onChanged: changeAmount,
          hintText: "Sum",
        ),
      ],
    );
  }
}

class MultiCategoryBudgetWidget extends StatelessWidget {
  final List<MultiCategoryBudgetUIModel> multiCategories;
  final Function() addMultiCategory;
  final Iterable<SelectionListItem<CategoryUIModel>> categories;
  final Iterable<SelectionListItem<WalletUIModel>> wallets;
  final Function(int index) removeMultiCategory;
  final Function(int index, CategoryUIModel category) changeCategoryInMultiCategory;
  final Function(int index, WalletUIModel wallet) changeWalletInMultiCategory;
  final Function(int index, String amount) changeAmountInMultiCategory;

  const MultiCategoryBudgetWidget(
      {Key? key,
      required this.multiCategories,
      required this.addMultiCategory,
      required this.categories,
      required this.wallets,
      required this.removeMultiCategory,
      required this.changeCategoryInMultiCategory,
      required this.changeWalletInMultiCategory,
      required this.changeAmountInMultiCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (multiCategories.isEmpty) {
      return Center(
        child: Column(
          children: [
            Text("You don't add any categories, please press plus for add"),
            PlatformElevatedButton(
              child: const Icon(Icons.add), //TODO
              onPressed: () {
                addMultiCategory();
              },
            ),
          ],
        ),
      );
    } else {
      var children = <Widget>[];
      for (var i = 0; i < multiCategories.length; i++) {
        final model = multiCategories[i];
        children.addAll([
          PlatformTextButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              removeMultiCategory(i);
            },
            child: Text("Remove category"),
          ),
          CommonBudgetWidget(
            changeAmount: (amount) {
              changeAmountInMultiCategory(i, amount);
            },
            showCategory: true,
            categories: categories.map((element) {
              final isSelected = model.category?.id == element.model.id;
              return SelectionListItem(
                  name: element.name, isSelected: isSelected, model: element.model);
            }),
            selectCategory: (category) {
              changeCategoryInMultiCategory(i, category);
            },
            wallets: wallets.map((wallet) {
              return SelectionListItem(
                  name: wallet.name,
                  model: wallet.model,
                  isSelected: model.wallets
                      .any((selectedWallet) => selectedWallet.id == wallet.model.id));
            }),
            selectWallet: (wallet) {
              changeWalletInMultiCategory(i, wallet);
            },
          ),
          const Divider(),
        ]);
      }

      children.add(Row(
        children: [
          Text("Add new category"),
          PlatformElevatedButton(
            child: const Icon(Icons.add), //TODO
            onPressed: () {
              addMultiCategory();
            },
          ),
        ],
      ));
      return Column(children: children);
    }
  }
}
