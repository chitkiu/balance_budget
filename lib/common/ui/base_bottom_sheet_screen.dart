import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottom_sheet_hide_icon.dart';
import 'get_widget_with_binding.dart';

abstract class BaseBottomSheetScreen<Binding extends Bindings, Controller>
    extends GetWidgetWithBinding<Binding, Controller> {
  final String? title;
  final IconData? tailing;
  const BaseBottomSheetScreen(
      {super.key, this.title, this.tailing, required super.bindingCreator});

  //TODO Maybe find better place
  void open() {
    Get.bottomSheet(
      this,
      isScrollControlled: true,
      //TODO Change color
      backgroundColor: Colors.white,
      //TODO Find or create constant for radius
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.0))),
    );
  }

  @override
  Widget view(BuildContext context) {
    final iconSize = IconTheme.of(context).size ?? 1.0;
    const padding = 12.0;

    return SingleChildScrollView(
        child: Column(children: [
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
                onTap: onTailingClick,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: Icon(tailing!, size: iconSize)),
              )
          ],
        ),
      body(context),
      //TODO Try to fetch uninteractable bottom padding
      SizedBox(
        height: MediaQuery.of(context).padding.bottom + 8,
      ),
    ]));
  }

  Widget body(BuildContext context);

  void onTailingClick() {}
}
