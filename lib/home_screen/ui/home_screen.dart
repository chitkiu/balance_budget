import 'package:balance_budget/categories/data/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'models/home_screen_tab.dart';
import 'mappers/home_screen_tab_mapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenTabMapper _mapper = const HomeScreenTabMapper();

  HomeScreenTab _currentItem = HomeScreenTab.spends;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        body: const Placeholder(),
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
