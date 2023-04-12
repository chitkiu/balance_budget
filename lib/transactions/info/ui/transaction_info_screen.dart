import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/get_widget_with_binding.dart';
import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';
import '../domain/transaction_info_binding.dart';
import '../domain/transaction_info_controller.dart';

//TODO Improve icons
class TransactionInfoScreen extends GetWidgetWithBinding<
    TransactionInfoBinding, TransactionInfoController> {
  const TransactionInfoScreen({required super.bindingCreator, super.key});

  @override
  Widget view(BuildContext context) {
    return CommonBottomSheetWidget(
      title: Get.localisation.transactionInfoTitle,
      tailing: CommonIcons.edit,
      onTailingClick: _onTailingClick,
      body: Obx(() {
        final model = controller.transaction.value;
        if (model == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CommonUI.defaultTileHorizontalPadding),
          child: Column(
            children: [
              if (model is CommonTransactionUIModel) ..._commonWidgets(model),
              if (model is TransferTransactionUIModel) ..._transferWidgets(model),
              const SizedBox(
                height: CommonUI.defaultFullTileVerticalPadding,
              ),
              PlatformElevatedButton(
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
          ),
        );
      }),
    );
  }

  List<Widget> _commonWidgets(CommonTransactionUIModel model) {
    return [
      CommonTile(
          secondText: model.sum,
          secondTextColor: model.sumColor,
          text: Get.localisation.transactionInfoSumPrefix,
          icon: Icons.euro),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      CommonTile(
          secondText: model.categoryName,
          text: Get.localisation.transactionInfoCategoryPrefix,
          icon: Icons.category),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      CommonTile(
          secondText: model.walletName,
          text: Get.localisation.transactionInfoWalletPrefix,
          icon: Icons.wallet),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      CommonTile(
          secondText: model.formattedDate,
          text: Get.localisation.transactionInfoTimePrefix,
          icon: Icons.calendar_month),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      if (model.comment != null)
        CommonTile(
            secondText: model.comment ?? '',
            text: Get.localisation.transactionInfoCommentPrefix,
            icon: Icons.comment),
    ];
  }

  List<Widget> _transferWidgets(TransferTransactionUIModel model) {
    return [
      CommonTile(
        secondText: model.sum,
        text: Get.localisation.transactionInfoSumPrefix,
        icon: Icons.euro,
      ),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      CommonTile(
        secondText: model.fromWalletName,
        text: Get.localisation.transactionInfoWalletPrefix,
        icon: Icons.arrow_drop_up,
      ),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      CommonTile(
        secondText: model.toWalletName,
        text: Get.localisation.transactionInfoWalletPrefix,
        icon: Icons.arrow_drop_down,
      ),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      CommonTile(
        secondText: model.formattedDate,
        text: Get.localisation.transactionInfoTimePrefix,
        icon: Icons.calendar_month,
      ),
    ];
  }

  void _onTailingClick(BuildContext context) => controller.goToEdit(context);
}
