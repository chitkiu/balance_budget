import 'package:balance_budget/budgets/list/ui/models/budget_ui_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../translator_extension.dart';
import '../domain/budgets_controller.dart';

class BudgetsScreen extends CommonScaffoldWithButtonScreen<BudgetsController> {
  BudgetsScreen({Key? key}) : super(
      Get.localisation.budgetTabName,
      cupertinoIcon: CupertinoIcons.add,
      materialIcon: Icons.add,
      key: key
  );

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      var budgets = controller.budgets;
      return ListView.builder(
        itemBuilder: (context, index) {
          var budget = budgets[index];
          if (budget is TotalBudgetUIModel) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(budget.name),
                Text("${budget.spendSum}/${budget.totalSum}"),
              ],
            );
          } else {
            return const Placeholder();
          }
        },
        itemCount: budgets.length,
      );
    });
  }

  @override
  void onButtonPress() {
    // controller.onAddClick();
  }

}