import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';

enum HomeScreenTab {
  transactions,
  budget,
  wallets,
  settings;
}

//TODO Maybe move to mapper
extension HomeScreenMapper on HomeScreenTab {
  IconData get icon {
    switch (this) {
      case HomeScreenTab.transactions:
        return CommonIcons.add;
      case HomeScreenTab.budget:
        return CommonIcons.dollarCircle;
      case HomeScreenTab.settings:
        return CommonIcons.settings;
      case HomeScreenTab.wallets:
        return CommonIcons.wallet;
    }
  }

  String get title {
    switch (this) {
      case HomeScreenTab.transactions:
        return Get.localisation.transactionsTabName;
      case HomeScreenTab.budget:
        return Get.localisation.budgetTabName;
      case HomeScreenTab.settings:
        return Get.localisation.settingsTabName;
      case HomeScreenTab.wallets:
        return Get.localisation.walletsTabName;
    }
  }
}
