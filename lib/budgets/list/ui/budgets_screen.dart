import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../domain/budgets_controller.dart';
import 'models/budget_ui_model.dart';

class BudgetsScreen extends CommonScaffoldWithButtonScreen<BudgetsController> {
  BudgetsScreen({Key? key}) : super(
      Get.localisation.budgetTabName,
      icon: CommonIcons.add,
      key: key
  );

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      var budgets = controller.budgets;
      return ListView.separated(
        itemBuilder: (context, index) {
          var budget = budgets[index];
          if (budget is TotalBudgetUIModel) {
            return Column(
              children: [
                const Text("Total",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(budget.name),
                    Text("${budget.spendSum}/${budget.totalSum}"),
                  ],
                )
              ],
            );
          } else if (budget is CategoryBudgetUIModel) {
            return Column(
              children: [
                const Text("Single category",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(budget.name),
                _categoryInfo(budget.categoryInfoUIModel),
              ],
            );
          } else if (budget is TotalBudgetWithCategoryUIModel) {
            return Column(
              children: <Widget>[
                const Text("Multi category",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(budget.name),
                    Text("${budget.spendSum}/${budget.totalSum}"),
                  ],
                )
              ] + budget.categoriesInfoUIModel.map(_categoryInfo).toList(),
            );
          } else {
            return const Placeholder();
          }
        },
        itemCount: budgets.length,
        separatorBuilder: (context, index) => const Divider(),
      );
    });
  }

  @override
  void onButtonPress() {
    controller.onAddClick();
  }

  Widget _categoryInfo(CategoryInfoUIModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(model.categoryName),
        Text("${model.spendSum}/${model.totalSum}"),
      ],
    );
  }

}