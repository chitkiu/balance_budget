import 'package:balance_budget/common/ui/common_ui_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'bottom_sheet_hide_icon.dart';

const _kShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)));

void openModalSheetWithController<C extends GetxController>(
    BuildContext context,
    Widget Function(C controller) bodyBuilder,
    C controller,
) {
  openModalSheet(
      context,
      GetBuilder(
        builder: bodyBuilder,
        init: controller,
      )
  );
}

void openModalSheet(BuildContext context, Widget body) {
  if (CommonUI.isCupertino) {
    showCupertinoModalBottomSheet(
        context: context, shape: _kShape, builder: (context) => body);
  } else {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => body,
        isDismissible: true,
        enableDrag: true,
        shape: _kShape);
  }
}

/// In most cases it will be bottom padding for widget when keyboard opened
const kDefaultBottomPaddingForPinToBottomWidget = 8;

class CommonBottomSheetWidget extends StatelessWidget {
  final String? title;
  final IconData? tailing;
  final Widget body;
  final Widget? pinToBottomWidget;
  final void Function(BuildContext context)? onTailingClick;
  final EdgeInsetsGeometry? additionalPadding;

  const CommonBottomSheetWidget({
    super.key,
    this.title,
    this.tailing,
    required this.body,
    this.pinToBottomWidget,
    this.onTailingClick,
    this.additionalPadding,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = MediaQuery.of(context).viewInsets;
    if (additionalPadding != null) {
      padding = padding.add(additionalPadding!);
    }
    final mainWidget = Padding(
      padding: padding,
      child: _BottomSheetWidget(
        body: body,
        title: title,
        tailing: tailing,
        onTailingClick: onTailingClick,
      ),
    );

    if (pinToBottomWidget != null) {
      return Stack(
        children: [
          mainWidget,
          Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom + kDefaultBottomPaddingForPinToBottomWidget,
              left: 0,
              right: 0,
              child: pinToBottomWidget!),
        ],
      );
    } else {
      return mainWidget;
    }
  }
}

class _BottomSheetWidget extends StatelessWidget {
  final String? title;
  final IconData? tailing;
  final void Function(BuildContext context)? onTailingClick;
  final Widget body;
  const _BottomSheetWidget({
    this.title,
    this.tailing,
    this.onTailingClick,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = IconTheme.of(context).size ?? 1.0;
    const padding = 12.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const BottomSheetHideIcon(),
        if (title != null || tailing != null)
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Added for symmetry title centering
              if (tailing != null)
                SizedBox(height: iconSize, width: iconSize + padding * 2),
              if (title != null)
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (tailing != null)
                GestureDetector(
                  onTap: () {
                    if (onTailingClick != null) {
                      onTailingClick!(context);
                    }
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: padding),
                      child: Icon(tailing!, size: iconSize)),
                )
            ],
          ),
        body,
        //TODO Try to fetch uninteractable bottom padding
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 8,
        ),
      ]),
    );
  }
}
