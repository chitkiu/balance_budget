import 'package:balance_budget/spends/list/domain/spends_controller.dart';
import 'package:balance_budget/spends/list/ui/spend_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'models/home_screen_tab.dart';

class HomeBodyBuilder {

  const HomeBodyBuilder();

  //TODO Change Get.put to self-created binding
  Widget getBody(HomeScreenTab tab) {
   switch (tab) {
     case HomeScreenTab.spends:
       Get.put(SpendsController());
       return const SpendScreen();
     case HomeScreenTab.budget:
       if (Get.isRegistered<SpendsController>()) {
         Get.delete<SpendsController>();
       }
       return const Placeholder();
     case HomeScreenTab.settings:
       if (Get.isRegistered<SpendsController>()) {
         Get.delete<SpendsController>();
       }
       return const Placeholder();
   }
  }

}