import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/widgets.dart';

CupertinoDropdownButtonData cupertinoDropdownButtonData(BuildContext context, PlatformTarget platform) {
  return CupertinoDropdownButtonData(
      itemHeight: 32,
      height: MediaQuery.of(context).size.height * 0.35
  );
}