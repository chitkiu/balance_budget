import 'package:balance_budget/common/getx_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dialog_helper.dart';

class CommonUI {
  CommonUI._();

  static final bool isCupertino =
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  static final dateFormatter = DateFormat('dd/MM/yyyy');

  static const defaultTileHorizontalPadding = 12.0;

  static const defaultTileVerticalPadding = 4.0;

  static const defaultFullTileVerticalPadding = defaultTileVerticalPadding * 2;

  static const defaultTilePadding = EdgeInsets.symmetric(
      horizontal: defaultTileHorizontalPadding,
      vertical: defaultTileVerticalPadding);
}

Future<void> confirmBeforeActionDialog(
  Future<void> Function() action, {
  String? title,
  String? subTitle,
  String? confirmAction,
  String? cancelAction,
}) async {
  var isConfirm = await DialogHelper.askForConfirmation(Get.overlayContext!,
      title: title ?? 'Are you sure?',
      isDangerousAction: true,
      query: subTitle ?? 'It\'s can\'t be undone!',
      action: confirmAction ?? Get.localisation.yes,
      cancelActionText: cancelAction ?? Get.localisation.no);
  if (isConfirm == true) {
    await action();
  }
}

Future<void> loadingDialogWhileExecution(
    BuildContext context,
    Future<void> Function() action,
) async {
  if (CommonUI.isCupertino) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        },
    );
  } else {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return WillPopScope(
              onWillPop: () async => false,
              child: const Dialog(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 15,
                      ),
                      //TODO Add translation
                      Text('Loading...')
                    ],
                  ),
                ),
              ),
          );
        });
  }
  await action();

  Navigator.pop(context);
}
