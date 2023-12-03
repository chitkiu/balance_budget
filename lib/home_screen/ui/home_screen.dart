import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../budgets/common/data/local_budget_repository.dart';
import '../../categories/common/data/local_category_repository.dart';
import '../../transactions/common/data/local_transactions_repository.dart';
import '../../wallets/common/data/local_wallet_repository.dart';
import 'home_body_builder.dart';
import 'mappers/home_screen_tab_mapper.dart';
import 'models/home_screen_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenTabMapper _mapper = const HomeScreenTabMapper();
  final HomeBodyBuilder _builder = HomeBodyBuilder();

  HomeScreenTab _currentItem = HomeScreenTab.transactions;

  @override
  void initState() {
    Get.lazyPut(() => context.read<LocalCategoryRepository>());
    Get.lazyPut(() => context.read<LocalWalletRepository>());
    Get.lazyPut(() => LocalTransactionsRepository());
    Get.lazyPut(() => LocalBudgetRepository());
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
