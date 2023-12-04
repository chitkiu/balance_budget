import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../categories/info/ui/category_info_screen.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/base_bottom_sheet_screen.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../../common/ui/transaction_item/models/transaction_ui_model.dart';
import '../../../wallets/info/ui/wallet_info_screen.dart';
import '../../common/data/local_transactions_repository.dart';
import '../../list/data/transactions_aggregator.dart';
import '../domain/transaction_info_cubit.dart';
import '../domain/transaction_info_state.dart';

class TransactionInfoScreen extends StatelessWidget {
  final String id;
  const TransactionInfoScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          final localTransactionsRepository = context.read<LocalTransactionsRepository>();
          return TransactionInfoCubit(
            id,
            localTransactionsRepository,
            TransactionsAggregator(localTransactionsRepository),
          );
        },
      child: const _TransactionInfoView(),
    );
  }
}

//TODO Improve icons
class _TransactionInfoView extends StatelessWidget {
  const _TransactionInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionInfoCubit, TransactionInfoState>(
        builder: (context, state) {
          final model = state.model;
          if (model == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return CommonBottomSheetWidget(
              title: Get.localisation.transactionInfoTitle,
              tailing: state.canEdit ? CommonIcons.edit : null,
              onTailingClick: _onTailingClick,
              body: Padding(
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
                            await context.read<TransactionInfoCubit>().deleteTransaction(model.id);
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
              ),
            );
          }
        },
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
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Get.back();
          Get.to(
                () => CategoryInfoScreen(model.categoryId),
            preventDuplicates: false,
          );
        },
        child: CommonTile(
            secondText: model.categoryName,
            text: Get.localisation.transactionInfoCategoryPrefix,
            icon: model.icon),
      ),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Get.back();
          Get.to(
                () => WalletInfoScreen(model.fromWalletId),
            preventDuplicates: false,
          );
        },
        child: CommonTile(
            secondText: model.fromWalletName,
            text: Get.localisation.transactionInfoWalletPrefix,
            icon: Icons.wallet),
      ),
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
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Get.back();
          Get.to(
                () => WalletInfoScreen(model.fromWalletId),
            preventDuplicates: false,
          );
        },
        child: CommonTile(
          secondText: model.fromWalletName,
          text: Get.localisation.transactionInfoWalletPrefix,
          icon: Icons.arrow_drop_up,
        ),
      ),
      const SizedBox(
        height: CommonUI.defaultFullTileVerticalPadding,
      ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Get.back();
          Get.to(
                () => WalletInfoScreen(model.toWalletId),
            preventDuplicates: false,
          );
        },
        child: CommonTile(
          secondText: model.toWalletName,
          text: Get.localisation.transactionInfoWalletPrefix,
          icon: Icons.arrow_drop_down,
        ),
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

  void _onTailingClick(BuildContext context) {
    context.read<TransactionInfoCubit>().goToEdit(context);
  }
}
