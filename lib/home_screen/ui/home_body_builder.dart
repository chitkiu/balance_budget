import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../transactions/list/domain/transactions_controller.dart';
import '../../transactions/list/ui/transactions_screen.dart';
import 'models/home_screen_tab.dart';

class HomeBodyBuilder {

  const HomeBodyBuilder();

  //TODO Change Get.put to self-created binding
  Widget getBody(HomeScreenTab tab) {
   switch (tab) {
     case HomeScreenTab.transactions:
       Get.put(TransactionsController());
       return TransactionsScreen();
     case HomeScreenTab.budget:
       if (Get.isRegistered<TransactionsController>()) {
         Get.delete<TransactionsController>();
       }
       return const Placeholder();
     case HomeScreenTab.settings:
       if (Get.isRegistered<TransactionsController>()) {
         Get.delete<TransactionsController>();
       }
       return const Placeholder();
   }
  }

}