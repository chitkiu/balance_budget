import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../list/ui/models/transaction_ui_model.dart';
import '../domain/transaction_info_controller.dart';

class TransactionInfoScreen extends StatefulWidget {
  final TransactionUIModel model;

  const TransactionInfoScreen(this.model, {Key? key}) : super(key: key);

  @override
  State<TransactionInfoScreen> createState() => _TransactionInfoScreenState();
}

class _TransactionInfoScreenState extends State<TransactionInfoScreen> {
  TransactionInfoController get controller => Get.find();

  bool _isInEditMode = false;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Transaction info"),
        trailingActions: [
          if (widget.model.canEdit)
            GestureDetector(
              onTap: _changeEditMode,
              child: Icon(_isInEditMode ? CommonIcons.check : CommonIcons.edit),
            )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.model is CommonTransactionUIModel)
            ..._commonWidgets(widget.model as CommonTransactionUIModel),

          if (widget.model is SetBalanceTransactionUIModel)
            ..._setBalanceWidgets(widget.model as SetBalanceTransactionUIModel),

          if (!_isInEditMode)
            PlatformTextButton(
              child: Text(Get.localisation.delete),
              onPressed: () async {
                await confirmBeforeActionDialog(
                  () async {
                    await controller.deleteTransaction(widget.model.id);
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
      ),
    );
  }

  void _changeEditMode() {
    if (widget.model.canEdit) {
      setState(() {
        _isInEditMode = !_isInEditMode;
      });
    }
  }

  List<Widget> _commonWidgets(CommonTransactionUIModel model) {
    return [
      Text(Get.localisation.transactionInfoSumPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.sum),

      Text(Get.localisation.transactionInfoCategoryPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.categoryName),

      Text(Get.localisation.transactionInfoAccountPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.accountName),

      Text(Get.localisation.transactionInfoTimePrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.time),
    ];
  }

  List<Widget> _setBalanceWidgets(SetBalanceTransactionUIModel model) {
    return [
      Text(Get.localisation.transactionInfoSumPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.sum),

      Text(Get.localisation.transactionInfoAccountPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.accountName),

      Text(Get.localisation.transactionInfoTimePrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.time),
    ];
  }

}
