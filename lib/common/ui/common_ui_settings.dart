import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

CupertinoDropdownButtonData cupertinoDropdownButtonData(BuildContext context, PlatformTarget platform) {
  return CupertinoDropdownButtonData(
      itemHeight: 32,
      height: MediaQuery.of(context).size.height * 0.35
  );
}

Future<void> confirmBeforeAction(
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