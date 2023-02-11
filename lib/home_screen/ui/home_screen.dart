import 'package:balance_budget/budgets/list/data/budget_aggregator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../accounts/common/data/local_account_repository.dart';
import '../../budgets/common/data/local_budget_repository.dart';
import '../../categories/common/data/local_category_repository.dart';
import '../../transactions/common/data/local_transactions_repository.dart';
import '../../transactions/list/data/transactions_aggregator.dart';
import 'home_body_builder.dart';
import 'mappers/home_screen_tab_mapper.dart';
import 'models/home_screen_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenTabMapper _mapper = const HomeScreenTabMapper();
  final HomeBodyBuilder _builder = const HomeBodyBuilder();

  HomeScreenTab _currentItem = HomeScreenTab.transactions;

  @override
  void initState() {
    Get.lazyPut(() => const Uuid());
    Get.lazyPut(() => LocalCategoryRepository());
    Get.lazyPut(() => LocalAccountRepository());
    Get.lazyPut(() => LocalTransactionsRepository());
    Get.lazyPut(() => LocalBudgetRepository());
    Get.lazyPut(() => const TransactionsAggregator());
    Get.lazyPut(() => const BudgetAggregator());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        body: _builder.getBody(_currentItem),
        material: (context, platform) {
          return MaterialScaffoldData(
              bottomNavBar: NavigationBar(
                destinations: HomeScreenTab.values.map(
                    _mapper.mapToNavigationDestination).toList(),
                onDestinationSelected: _onSelectTab,
                selectedIndex: _currentItem.index,
              )
          );
        },
        bottomNavBar: PlatformNavBar(
          items: HomeScreenTab.values.map(_mapper.mapToBottomNavigationBarItem)
              .toList(),
          currentIndex: _currentItem.index,
          itemChanged: _onSelectTab,
        )
    );
  }

  void _onSelectTab(int newIndex) {
    HomeScreenTab newItem = HomeScreenTab.values[newIndex];
    if (newItem != _currentItem) {
      setState(() {
        _currentItem = newItem;
      });
    }
  }
}
