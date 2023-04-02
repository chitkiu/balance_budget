import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../list/ui/models/transaction_ui_model.dart';
import '../domain/transaction_info_binding.dart';
import '../domain/transaction_info_controller.dart';

//TODO Improve icons
class TransactionInfoScreen
    extends BaseBottomSheetScreen<TransactionInfoBinding, TransactionInfoController> {
  TransactionInfoScreen({required super.bindingCreator, super.key})
      : super(title: Get.localisation.transactionInfoTitle, tailing: CommonIcons.edit);

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      final model = controller.transaction.value;
      if (model == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
        children: [
          if (model is CommonTransactionUIModel) ..._commonWidgets(model),
          if (model is TransferTransactionUIModel) ..._transferWidgets(model),
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
          ),
        ],
      );
    });
  }

  List<Widget> _commonWidgets(CommonTransactionUIModel model) {
    return [
      _getTransactionInfoItem(
          model.sum,
          textColor: model.sumColor,
          Get.localisation.transactionInfoSumPrefix,
          Icons.euro),
      _getTransactionInfoItem(model.categoryName,
          Get.localisation.transactionInfoCategoryPrefix, Icons.category),
      _getTransactionInfoItem(
          model.walletName, Get.localisation.transactionInfoWalletPrefix, Icons.wallet),
      _getTransactionInfoItem(
          model.formattedDate, Get.localisation.transactionInfoTimePrefix, Icons.calendar_month),
      if (model.comment != null)
        _getTransactionInfoItem(model.comment ?? '',
            Get.localisation.transactionInfoCommentPrefix, Icons.comment),
    ];
  }

  List<Widget> _transferWidgets(TransferTransactionUIModel model) {
    return [
      _getTransactionInfoItem(
        model.sum,
        Get.localisation.transactionInfoSumPrefix,
        Icons.euro,
      ),
      _getTransactionInfoItem(
        model.fromWalletName,
        Get.localisation.transactionInfoWalletPrefix,
        Icons.arrow_drop_up,
      ),
      _getTransactionInfoItem(
        model.toWalletName,
        Get.localisation.transactionInfoWalletPrefix,
        Icons.arrow_drop_down,
      ),
      _getTransactionInfoItem(
        model.formattedDate,
        Get.localisation.transactionInfoTimePrefix,
        Icons.calendar_month,
      ),
    ];
  }

  Widget _getTransactionInfoItem(String text, String prefix, IconData icon,
      {Color? textColor}) {
    return PlatformListTile(
      title:
          Text(prefix, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      subtitle: Text(text,
          style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 17)),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.withOpacity(0.3),
        child: Icon(icon),
      ),
    );
  }

  @override
  void onTailingClick() => controller.goToEdit();
}
