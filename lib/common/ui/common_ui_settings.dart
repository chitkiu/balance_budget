import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import 'dialog_helper.dart';
import 'platform_dropdown_button.dart';

class CommonUI {

  CommonUI._();

  static final bool isCupertino =
  (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS);

}

CupertinoDropdownButtonData cupertinoDropdownButtonData(BuildContext context, PlatformTarget platform) {
  return CupertinoDropdownButtonData(
      itemHeight: 32,
      height: MediaQuery.of(context).size.height * 0.35
  );
}

Future<void> confirmBeforeActionDialog(
    Future<void> Function() action,
{
  String? title,
  String? subTitle,
  String? confirmAction,
  String? cancelAction,
}
) async {
  var isConfirm = await DialogHelper.askForConfirmation(
      Get.overlayContext!,
      title: title ?? 'Are you sure?',
      isDangerousAction: true,
      query: subTitle ?? 'It\'s can\'t be undone!',
      action: confirmAction ?? 'Yes',
      cancelActionText: cancelAction ?? 'No'
  );
  if (isConfirm == true) {
    await action();
  }
}