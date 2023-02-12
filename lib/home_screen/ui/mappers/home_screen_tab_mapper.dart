import 'package:flutter/material.dart';

import '../models/home_screen_tab.dart';

class HomeScreenTabMapper {

  const HomeScreenTabMapper();

  NavigationDestination mapToNavigationDestination(HomeScreenTab tab) {
    return NavigationDestination(
      icon: Icon(tab.icon),
      label: tab.title,
    );
  }

  BottomNavigationBarItem mapToBottomNavigationBarItem(HomeScreenTab tab) {
    return BottomNavigationBarItem(
      icon: Icon(tab.icon),
      label: tab.title,
    );
  }
}