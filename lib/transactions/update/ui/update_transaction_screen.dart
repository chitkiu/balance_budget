import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/common_colors.dart';
import '../../../common/ui/common_selection_list.dart';
import '../../../common/ui/common_toggle_buttons.dart';
import '../../common/data/models/rich_transaction_model.dart';
import '../../update/ui/date_time_selector_widget.dart';
import '../domain/update_transaction_controller.dart';

const double _buttonHeight = 48;

class UpdateTransactionScreen extends StatelessWidget {
  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  final _sumInputKey = GlobalKey<FormFieldState>();

  final String title;

  final UpdateTransactionController controller;

  UpdateTransactionScreen(
      {RichTransactionModel? model,
      required this.title,
      required this.controller,
      super.key})
      : super() {
    if (model != null) {
      _setupInfoByModel(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaBottomPadding = MediaQuery.of(context).padding.bottom;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: CommonBottomSheetWidget(
        title: title,
        additionalPadding: const EdgeInsets.only(
            bottom: _buttonHeight + kDefaultBottomPaddingForPinToBottomWidget),
        body: Column(
          children: [
            Text(Get.localisation.transactionTypeHint),
            Obx(() {
              return CommonToggleButtons(
                onItemClick: (index) async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  controller.selectType(TransactionType.showInTransactionList[index]);
                },
                isSelected: TransactionType.showInTransactionList
                    .map((e) => e == controller.selectedType.value)
                    .toList(),
                fillColor:
                    _getBackgroundColorBySelectedType(controller.selectedType.value),
                children: TransactionType.showInTransactionList.map((e) {
                  return Text(e.name);
                }).toList(),
              );
            }),
            const SizedBox(
              height: 8,
            ),
            PlatformTextFormField(
              widgetKey: _sumInputKey,
              validator: controller.validateNumber,
              keyboardType:
                  const TextInputType.numberWithOptions(signed: true, decimal: true),
              controller: _sumController,
              material: (context, platform) {
                return MaterialTextFormFieldData(
                    decoration: InputDecoration(
                        labelText: Get.localisation.addTransactionSumHint));
              },
              cupertino: (context, platform) {
                return CupertinoTextFormFieldData(
                    placeholder: Get.localisation.addTransactionSumHint);
              },
            ),
            Obx(() {
              if (controller.selectedType.value != TransactionType.transfer) {
                final categoryError = controller.categoryError.value;
                return Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Get.localisation.addTransactionCategoryHint),
                        PlatformTextButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            controller.onManageCategoriesClick();
                          },
                          child: Text(Get.localisation.manageCategoriesButtonText),
                        )
                      ],
                    ),
                    CommonSelectionList(
                        items: controller.categoryList.value,
                        onClick: controller.selectCategory),
                    if (categoryError != null)
                      Text(
                        categoryError, style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.start,),
                  ],
                );
              } else {
                return Container();
              }
            }),
            Obx(() {
              final fromWalletError = controller.fromWalletError.value;
              return Column(
                children: [
                  ..._selectWallet(
                      context, controller.selectedWallet.value, controller.selectWallet),
                  if (fromWalletError != null)
                    Text(
                      fromWalletError, style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.start,),
                ],
              );
            }),
            Obx(() {
              if (controller.selectedType.value == TransactionType.transfer) {
                final toWalletError = controller.toWalletError.value;
                return Column(
                  children: [
                    ..._selectWallet(context, controller.selectedToWallet.value,
                        controller.selectToWallet),
                    if (toWalletError != null)
                      Text(
                        toWalletError, style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.start,),
                  ],
                );
              } else {
                return Container();
              }
            }),
            const SizedBox(
              height: 8,
            ),
            PlatformTextField(
              controller: _commentController,
              material: (context, platform) {
                return MaterialTextFieldData(
                    decoration: InputDecoration(
                        labelText: Get.localisation.addTransactionCommentHint));
              },
              cupertino: (context, platform) {
                return CupertinoTextFieldData(
                    placeholder: Get.localisation.addTransactionCommentHint);
              },
            ),
            const SizedBox(
              height: 8,
            ),
            DateTimeSelectorWidget(
              controller.selectedDate,
              (p0, p1) {
                FocusScope.of(context).requestFocus(FocusNode());
                controller.selectDateByType(p0, p1);
              },
            ),
          ],
        ),
        pinToBottomWidget: SizedBox(
          height: _buttonHeight + safeAreaBottomPadding,
          child: Padding(
              padding: EdgeInsets.only(left: 4, right: 4, bottom: safeAreaBottomPadding),
              child: PlatformElevatedButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  onButtonPress();
                },
                child: Text(Get.localisation.save_button),
              )),
        ),
      ),
    );
  }

  void onButtonPress() {
    if (_sumInputKey.currentState?.validate() == true) {
      controller.onSaveTransaction(_sumController.text, _commentController.text);
    }
  }

  List<Widget> _selectWallet(
    BuildContext context,
    List<SelectionListItem<String>> selectedWallet,
    void Function(String) onWalletSelected,
  ) {
    return [
      const SizedBox(
        height: 8,
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Get.localisation.addTransactionWalletHint),
          PlatformTextButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              controller.onManageWalletsClick();
            },
            child: Text(Get.localisation.manageWalletsButtonText),
          )
        ],
      ),
      CommonSelectionList(items: selectedWallet, onClick: onWalletSelected),
    ];
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

  final NumberFormat _sumFormatter = NumberFormat("##0.##");

  void _setupInfoByModel(RichTransactionModel model) {
    _sumController.text = _sumFormatter.format(model.transaction.sum);
    _commentController.text = model.transaction.comment ?? '';
  }
}
