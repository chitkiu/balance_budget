import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_bloc_scaffold_with_button_screen.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_tile.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../common/data/local_wallet_repository.dart';
import '../domain/wallets_list_cubit.dart';
import '../domain/wallets_list_state.dart';
import 'models/wallet_ui_model.dart';

class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletsListCubit>(
      create: (context) => WalletsListCubit(
        Get.find<LocalWalletRepository>(), //TODO Rewrite to BLoC
      ),
      child: _WalletsView(),
    );
  }
}

class _WalletsView extends CommonBlocScaffoldWithButtonScreen {
  _WalletsView() : super(Get.localisation.walletsTitle, icon: CommonIcons.add);

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<WalletsListCubit, WalletsListState>(
      builder: (context, state) {
        final wallets = state.items;
        switch (state.status) {
          case WalletsListStatus.initial:
            return const SizedBox.shrink();
          case WalletsListStatus.loading:
            return Center(
              child: PlatformCircularProgressIndicator(),
            );
          case WalletsListStatus.success:
            if (wallets.isEmpty) {
              return Center(
                child: Text(Get.localisation.noWallets),
              );
            }
            return ListView.separated(
              itemBuilder: (context, index) => _walletWidget(context, wallets[index]),
              itemCount: wallets.length,
              separatorBuilder: (context, index) => const Divider(),
            );
          case WalletsListStatus.failure:
            return Center(
              child: Text("Error:\n${state.error}"),
            );
        }
      },
    );
  }

  @override
  void onButtonPress(BuildContext context) {
    context.read<WalletsListCubit>().onAddClick();
  }

  Widget _walletWidget(BuildContext context, WalletUIModel wallet) {
    final textTheme = Theme.of(context).textTheme;

    Widget? additionalText;

    if (wallet is CreditWalletUIModel) {
      additionalText = Text(
          Get.localisation.usedCreditLimit(wallet.spendCreditSum, wallet.totalCreditSum),
          style: textTheme.titleSmall);
    }

    Color? iconColor;

    if (wallet.isArchived) {
      iconColor = Colors.grey;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.read<WalletsListCubit>().onItemClick(wallet);
      },
      child: Padding(
        padding: CommonUI.defaultTilePadding,
        child: CommonTile(
          icon: CommonIcons.wallet,
          iconColor: iconColor,
          textWidget: Text(
            wallet.name,
            style: textTheme.titleMedium,
          ),
          secondTextWidget: Text(Get.localisation.totalBalance(wallet.balance),
              style: textTheme.titleSmall),
          additionalTextWidget: additionalText,
        ),
      ),
    );
  }
}
