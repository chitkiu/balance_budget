import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/common_icons.dart';
import '../../list/data/models/rich_transaction_model.dart';
import '../../update/ui/date_time_selector_widget.dart';
import '../domain/update_transaction_binding.dart';
import '../domain/update_transaction_controller.dart';
import 'models/transaction_wallet_ui_model.dart';

class UpdateTransactionScreen extends BaseBottomSheetScreen<
    UpdateTransactionBinding, UpdateTransactionController> {
  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  UpdateTransactionScreen(
      {RichTransactionModel? model,
      required super.title,
      required super.bindingCreator,
      super.key}) {
    if (model != null) {
      _setupInfoByModel(model);
    }
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Text(Get.localisation.transactionTypeHint),
        _transactionTypeSelector(),
        const SizedBox(
          height: 8,
        ),
        PlatformTextField(
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          controller: _sumController,
          material: (context, platform) {
            return MaterialTextFieldData(
                decoration: InputDecoration(
                    labelText: Get.localisation.addTransactionSumHint));
          },
          cupertino: (context, platform) {
            return CupertinoTextFieldData(
                placeholder: Get.localisation.addTransactionSumHint);
          },
        ),
        Obx(() {
          if (controller.selectedType.value != TransactionType.transfer) {
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
                      onPressed: controller.onManageCategoriesClick,
                      child: Text(Get.localisation.manageCategoriesButtonText),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: Obx(() {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: controller.categoryList.map((element) {
                        return PlatformTextButton(
                          onPressed: () {
                            controller.selectCategory(element);
                          },
                          child: Row(
                            children: [
                              Text(element.title),
                              if (element.isSelected) Icon(CommonIcons.ok)
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ),
              ],
            );
          } else {
            return Container();
          }
        }),
        ..._selectWallet(
            controller.selectedWallet, (p0) => controller.selectWallet(p0)),
        Obx(() {
          if (controller.selectedType.value == TransactionType.transfer) {
            return Column(
              children: _selectWallet(controller.selectedToWallet,
                  (p0) => controller.selectToWallet(p0)),
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
          controller.selectDateByType,
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: PlatformElevatedButton(
            onPressed: onButtonPress,
            child: Text(Get.localisation.save_button),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  void onButtonPress() {
    controller.onSaveTransaction(_sumController.text, _commentController.text);
  }

  List<Widget> _selectWallet(
    Rxn<String> selectedWallet,
    void Function(TransactionWalletUIModel) onWalletSelected,
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
            onPressed: controller.onManageWalletsClick,
            child: Text(Get.localisation.manageWalletsButtonText),
          )
        ],
      ),
      SizedBox(
        height: 50,
        child: Obx(() {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: controller.walletList.map((element) {
              return PlatformTextButton(
                onPressed: () {
                  onWalletSelected(element);
                },
                child: Row(
                  children: [
                    Text(element.title),
                    if (selectedWallet.value == element.walletId)
                      Icon(CommonIcons.ok)
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ),
    ];
  }

  Widget _transactionTypeSelector() {
    return LayoutBuilder(builder: (buildContext, constraints) {
      return Obx(() {
        return ToggleButtons(
          onPressed: (index) async {
            var type = TransactionType.showInTransactionList[index];
            controller.selectedType.value = type;
          },
          isSelected: TransactionType.showInTransactionList
              .map((e) => e == controller.selectedType.value)
              .toList(),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.grey,
          borderColor: Colors.grey,
          selectedColor: Colors.white,
          fillColor:
              _getBackgroundColorBySelectedType(controller.selectedType.value),
          color: Colors.black,
          constraints: BoxConstraints(
            minHeight: 40.0,
            minWidth: (constraints.maxWidth - 8 * 2) /
                TransactionType.showInTransactionList.length,
          ),
          children: TransactionType.showInTransactionList.map((e) {
            return Text(e.name);
          }).toList(),
        );
      });
    });
  }

  Color _getBackgroundColorBySelectedType(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return Colors.redAccent;
      case TransactionType.income:
        return Colors.green;
      case TransactionType.transfer:
        return Colors.grey;
      case TransactionType.setInitialBalance:
        return Colors.grey;
    }
  }

  void _setupInfoByModel(RichTransactionModel model) {
    //TODO Add format
    _sumController.text = model.transaction.sum.toString();
    _commentController.text = model.transaction.comment ?? '';
  }
}
