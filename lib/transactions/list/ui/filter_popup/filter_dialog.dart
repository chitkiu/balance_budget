import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/data/models/transaction_type.dart';
import '../../../../common/getx_extensions.dart';
import '../../../../common/ui/common_colors.dart';
import '../../../../common/ui/common_toggle_buttons.dart';

//TODO Remove this method and move it to TransactionController
Future<void> showFilterDialog({
  required BuildContext context,
}) {
  //TODO Rewrite to openModalSheetWithController
  Rx<TransactionType> selectedType = TransactionType.income.obs;
  var dialog = Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    backgroundColor: Theme
        .of(context)
        .canvasColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      width: 325,
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Get.localisation.transactionTypeHint),
          Obx(() {
            return CommonToggleButtons(
              onItemClick: (index) async {
                FocusScope.of(context).requestFocus(FocusNode());
                selectedType.value = TransactionType.showInTransactionList[index];
              },
              isSelected: TransactionType.showInTransactionList
                  .map((e) => e == selectedType.value)
                  .toList(),
              fillColor:
              _getBackgroundColorBySelectedType(selectedType.value),
              children: TransactionType.showInTransactionList.map((e) {
                return Text(e.name);
              }).toList(),
            );
          }),
        ],
      ),
    ),
  );

  return showDialog(
    context: context,
    useRootNavigator: true,
    routeSettings: null,
    builder: (BuildContext context) {
      return dialog;
    },
    barrierDismissible: true,
    barrierColor: Colors.black54,
    barrierLabel: null,
    useSafeArea: true,
  );
}

Color _getBackgroundColorBySelectedType(TransactionType type) {
  switch (type) {
    case TransactionType.expense:
      return CommonColors.expense;
    case TransactionType.income:
      return CommonColors.income;
    case TransactionType.transfer:
    case TransactionType.setInitialBalance:
      return CommonColors.defColor;
  }
}