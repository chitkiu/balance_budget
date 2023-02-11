import 'package:balance_budget/budgets/list/ui/budgets_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../budgets/list/domain/budgets_controller.dart';
import '../../settings/domain/settings_controller.dart';
import '../../settings/ui/settings_screen.dart';
import '../../transactions/list/domain/transactions_controller.dart';
import '../../transactions/list/ui/transactions_screen.dart';
import 'models/home_screen_tab.dart';

class HomeBodyBuilder {

  const HomeBodyBuilder();

  //TODO Change Get.put to self-created binding
  Widget getBody(HomeScreenTab tab) {
   switch (tab) {
     case HomeScreenTab.transactions:
       if (Get.isRegistered<SettingsController>()) {
         Get.delete<SettingsController>();
       }
       if (Get.isRegistered<BudgetsController>()) {
         Get.delete<BudgetsController>();
       }
       Get.put(TransactionsController());
       return TransactionsScreen();
     case HomeScreenTab.budget:
       if (Get.isRegistered<TransactionsController>()) {
         Get.delete<TransactionsController>();
       }
       if (Get.isRegistered<SettingsController>()) {
         Get.delete<SettingsController>();
       }
       Get.put(BudgetsController());
       return BudgetsScreen();
     case HomeScreenTab.settings:
       if (Get.isRegistered<TransactionsController>()) {
         Get.delete<TransactionsController>();
       }
       if (Get.isRegistered<BudgetsController>()) {
         Get.delete<BudgetsController>();
       }
       Get.put(SettingsController());
       return const SettingsScreen();
   }
  }

}