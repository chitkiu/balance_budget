import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'common_ui_settings.dart';

class CommonIcons {
  CommonIcons._();

  static Map<String, IconData> icons = ioniconsMapping.map((key, value) =>
      MapEntry(key, IoniconsData(int.parse(value))));

  static bool get _isCupertino => CommonUI.isCupertino;

  static IconData get ok =>
      _isCupertino ? CupertinoIcons.check_mark : Icons.done;

  static IconData get cancel => CupertinoIcons.clear;

  static IconData get back =>
      _isCupertino ? CupertinoIcons.back : Icons.arrow_back;

  static IconData get add => _isCupertino ? CupertinoIcons.add : Icons.add;

  static IconData get check => _isCupertino ? CupertinoIcons.checkmark : Icons.check;

  static IconData get edit => _isCupertino ? CupertinoIcons.pencil : Icons.edit;

  static IconData get dollarCircle =>
      _isCupertino ? CupertinoIcons.money_dollar_circle_fill : Icons.monetization_on;

  static IconData get settings => _isCupertino ? CupertinoIcons.settings : Icons.settings;

  static IconData get note => _isCupertino ? CupertinoIcons.text_alignleft : Icons.notes;

  static IconData get wallet => Icons.wallet;

  static IconData get arrowUp => Icons.keyboard_arrow_up_sharp;

  static IconData get arrowDown => Icons.keyboard_arrow_down_sharp;

  static IconData get filter => Icons.filter_list;

  static IconData get calendar =>
      _isCupertino ? CupertinoIcons.calendar_today : Icons.calendar_month;
}