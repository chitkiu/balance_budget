import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/get_widget_with_binding.dart';
import '../../list/ui/models/transaction_ui_model.dart';
import '../domain/transaction_info_binding.dart';
import '../domain/transaction_info_controller.dart';

class TransactionInfoScreen extends GetWidgetWithBinding<TransactionInfoBinding, TransactionInfoController> {
  final String transactionId;

  TransactionInfoScreen(this.transactionId, {required super.bindingCreator, super.key});

  final RxBool _isInEditMode = false.obs;

  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget view() {
    return StreamBuilder(
      stream: controller.transactionById(transactionId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var model = snapshot.data!;

          return PlatformScaffold(
            appBar: PlatformAppBar(
              title: Obx(() {
                String title;
                if (_isInEditMode.value) {
                  title = Get.localisation.transactionInfoEditTitle;
                } else {
                  title = Get.localisation.transactionInfoTitle;
                }
                return Text(title);
              }),
              automaticallyImplyLeading: false,
              trailingActions: [
                if (model.canEdit)
                  GestureDetector(
                    onTap: () => _onTrailing(model),
                    child: Obx(() {
                      return Icon(
                          _isInEditMode.value
                              ? CommonIcons.check
                              : CommonIcons.edit);
                    }),
                  )
              ],
              leading: GestureDetector(
                onTap: () => _onLeading(model),
                child: Icon(CommonIcons.cancel),
              ),
              cupertino: (context, platform) {
                CupertinoButton? trailing;
                if (model.canEdit) {
                  trailing = CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _onTrailing(model),
                    child: Obx(() {
                      return Text(
                        _isInEditMode.value
                            ? Get.localisation.save_bottom_sheet
                            : Get.localisation.edit_bottom_sheet,
                      );
                    },
                    ),
                  );
                }
                return CupertinoNavigationBarData(
                    trailing: trailing,
                    leading: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(Get.localisation.cancel_bottom_sheet),
                        onPressed: () => _onLeading(model)
                    )
                );
              },
            ),
            body: SafeArea(
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (model is CommonTransactionUIModel)
                      ..._commonWidgets(model, _isInEditMode.value),
                    if (model is TransferTransactionUIModel)
                      ..._transferWidgets(model),
                    if (!_isInEditMode.value)
                      PlatformTextButton(
                        child: Text(Get.localisation.delete),
                        onPressed: () async {
                          await confirmBeforeActionDialog(
                            () async {
                              await controller.deleteTransaction(model.id);
                              Get.back();
                            },
                            title: Get.localisation.confirmToDeleteTitle,
                            subTitle: Get.localisation.confirmToDeleteText,
                            confirmAction: Get.localisation.yes,
                            cancelAction: Get.localisation.no,
                          );
                        },
                      )
                  ],
                );
              }),
            ),
          );
        } else {
          return PlatformScaffold(
            appBar: PlatformAppBar(
              title: Text(Get.localisation.loading),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void _editTransaction(TransactionUIModel model) {
    controller.editTransaction(
      model.id,
      newSum: _sumController.text,
      newComment: _commentController.text,
    );
  }

  final NumberFormat _sumFormatter = NumberFormat("#.##");

  void _updateControllers(TransactionUIModel model, bool isInEditMode) {
    if (isInEditMode) {
      _sumController.clear();
      _commentController.clear();
    } else {
      _sumController.text = _sumFormatter.format(model.sumDouble);
      _commentController.text = model.comment ?? '';
    }
  }

  void _updateOnChangeMode(TransactionUIModel model, bool isInEditMode) {
    if (model.canEdit) {
      if (isInEditMode) {
        _editTransaction(model);
      }
      _updateControllers(model, isInEditMode);
    }
  }

  List<Widget> _commonWidgets(CommonTransactionUIModel model, bool isInEditMode) {
    return [
      Text(Get.localisation.transactionInfoSumPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      if (!isInEditMode)
        Text(
          model.sum,
          style: TextStyle(color: model.sumColor),
        ),
      if (isInEditMode)
        PlatformTextField(
          controller: _sumController,
        ),
      Text(Get.localisation.transactionInfoCategoryPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.categoryName),
      Text(Get.localisation.transactionInfoWalletPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.walletName),
      Text(Get.localisation.transactionInfoTimePrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.formattedDate),
      if (model.comment != null || isInEditMode)
        Text(Get.localisation.transactionInfoCommentPrefix,
            style: const TextStyle(fontWeight: FontWeight.w500)),
      if (model.comment != null && !isInEditMode) Text(model.comment ?? ''),
      if (isInEditMode)
        PlatformTextField(
          controller: _commentController,
        ),
    ];
  }

  List<Widget> _transferWidgets(TransferTransactionUIModel model) {
    return [
      Text(Get.localisation.transactionInfoSumPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.sum),
      Text(Get.localisation.transactionInfoWalletPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text("${model.fromWalletName} => ${model.toWalletName}"),
      Text(Get.localisation.transactionInfoTimePrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.formattedDate),
    ];
  }

  void _onTrailing(TransactionUIModel model) {
    _updateOnChangeMode(model, _isInEditMode.value);
    _isInEditMode.value = !_isInEditMode.value;
  }

  void _onLeading(TransactionUIModel model) {
    if (_isInEditMode.value) {
      _updateControllers(model, false);
      _isInEditMode.value = false;
    } else {
      Get.back();
    }
  }
}
