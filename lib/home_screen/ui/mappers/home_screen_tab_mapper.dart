import 'package:balance_budget/translator_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/home_screen_tab.dart';

class HomeScreenTabMapper {

  const HomeScreenTabMapper();

  NavigationDestination mapToNavigationDestination(HomeScreenTab tab) {
    return NavigationDestination(
      icon: Icon(tab.icon),
      label: _getText(tab),
    );
  }

  BottomNavigationBarItem mapToBottomNavigationBarItem(HomeScreenTab tab) {
    return BottomNavigationBarItem(
      icon: Icon(tab.icon),
      label: _getText(tab),
    );
  }

  String _getText(HomeScreenTab tab) {
    switch (tab) {
      case HomeScreenTab.transactions:
        return Get.localisation.transactionsTabName;
      case HomeScreenTab.budget:
        return Get.localisation.budgetTabName;
      case HomeScreenTab.settings:
        return Get.localisation.settingsTabName;
    }
  }
}