import 'package:flutter/material.dart';

//TODO Make it crossplatform
enum HomeScreenTab {
  spends(Icons.add),
  budget(Icons.monetization_on),
  settings(Icons.settings);

  final IconData icon;

  const HomeScreenTab(this.icon);
}