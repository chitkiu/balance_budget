import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonIcons {
  CommonIcons._();

  static final _isCupertino = PlatformInfo.isCupertino;

  static IconData get add => _isCupertino ? CupertinoIcons.add : Icons.add;

  static IconData get check => _isCupertino ? CupertinoIcons.checkmark : Icons.check;

  static IconData get edit => _isCupertino ? CupertinoIcons.pencil : Icons.edit;

  static IconData get dollarCircle => _isCupertino ? CupertinoIcons.money_dollar_circle_fill : Icons.monetization_on;

  static IconData get settings => _isCupertino ? CupertinoIcons.settings : Icons.settings;

  static IconData get note => _isCupertino ? CupertinoIcons.text_alignleft : Icons.notes;

  static IconData get wallet => Icons.wallet;

  static IconData get arrowUp => Icons.keyboard_arrow_up_sharp;

  static IconData get arrowDown => Icons.keyboard_arrow_down_sharp;
}