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
  final String transactionId;

  const TransactionInfoScreen(this.transactionId, {Key? key}) : super(key: key);

  @override
  State<TransactionInfoScreen> createState() => _TransactionInfoScreenState();
}

class _TransactionInfoScreenState extends State<TransactionInfoScreen> {

  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  TransactionInfoController get controller => Get.find();

  bool _isInEditMode = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.transactionById(widget.transactionId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var model = snapshot.data!;
          return PlatformScaffold(
            appBar: PlatformAppBar(
              title: Text(Get.localisation.transactionInfoTitle),
              trailingActions: [
                if (model.canEdit)
                  GestureDetector(
                    onTap: () => _changeEditMode(model),
                    child: Icon(_isInEditMode ? CommonIcons.check : CommonIcons.edit),
                  )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (model is CommonTransactionUIModel)
                  ..._commonWidgets(model),

                if (model is SetBalanceTransactionUIModel)
                  ..._setBalanceWidgets(model),

                if (!_isInEditMode)
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
            ),
          );
        } else {
          //TODO Add loader
          return const Placeholder();
        }
      },
    );
  }

  void _changeEditMode(TransactionUIModel model) {
    if (model.canEdit) {
      if (_isInEditMode) {
        controller.editTransaction(
            model.id,
            newSum: _sumController.text,
            newComment: _commentController.text,
        );
        _sumController.clear();
        _commentController.clear();
      } else {
        _sumController.text = model.sum;
        _commentController.text = model.comment ?? '';
      }
      setState(() {
        _isInEditMode = !_isInEditMode;
      });
    }
  }

  List<Widget> _commonWidgets(CommonTransactionUIModel model) {
    return [
      Text(Get.localisation.transactionInfoSumPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      if (!_isInEditMode)
        Text(model.sum, style: TextStyle(color: model.sumColor),),
      if (_isInEditMode)
        PlatformTextField(
          controller: _sumController,
        ),

      Text(Get.localisation.transactionInfoCategoryPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.categoryName),

      Text(Get.localisation.transactionInfoAccountPrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.accountName),

      Text(Get.localisation.transactionInfoTimePrefix,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(model.time),

      if (model.comment != null || _isInEditMode)
        Text(Get.localisation.transactionInfoCommentPrefix,
            style: const TextStyle(fontWeight: FontWeight.w500)),
      if (model.comment != null && !_isInEditMode)
        Text(model.comment ?? ''),
      if (_isInEditMode)
        PlatformTextField(
          controller: _commentController,
        ),
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
