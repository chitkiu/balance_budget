import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../budgets/list/domain/budgets_binding.dart';
import '../../budgets/list/ui/budgets_screen.dart';
import '../../common/domain/models/deletable_bindings.dart';
import '../../settings/domain/settings_binding.dart';
import '../../settings/ui/settings_screen.dart';
import '../../transactions/list/domain/transactions_binding.dart';
import '../../transactions/list/ui/transactions_screen.dart';
import '../../wallets/list/domain/wallets_binding.dart';
import '../../wallets/list/ui/wallets_screen.dart';
import 'models/home_screen_tab.dart';

class HomeBodyBuilder {
  final Map<HomeScreenTab, Bindings> _itemBindings = {
    HomeScreenTab.transactions : TransactionsBinding(),
    HomeScreenTab.wallets : WalletsBinding(),
    HomeScreenTab.settings : SettingsBinding(),
    HomeScreenTab.budget : BudgetsBinding(),
  };

  Widget getBody(HomeScreenTab tab) {
    _itemBindings[tab]?.dependencies();
    for (var element in _itemBindings.entries) {
      if (element.key != tab && element.value is DeletableBindings) {
        (element.value as DeletableBindings).delete();
      }
    }

    switch (tab) {
      case HomeScreenTab.transactions:
        return const TransactionsScreen();
      case HomeScreenTab.budget:
        return BudgetsScreen();
      case HomeScreenTab.settings:
        return const SettingsScreen();
      case HomeScreenTab.wallets:
        return WalletsScreen();
    }
  }

}