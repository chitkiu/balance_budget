import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../common/domain/name_validator.dart';
import '../../../common/domain/number_validator.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_bloc_scaffold_with_button_screen.dart';
import '../../../common/ui/common_colors.dart';
import '../../../common/ui/common_edit_text.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_toggle_buttons.dart';
import '../../common/data/local_wallet_repository.dart';
import '../domain/add_wallet_cubit.dart';
import '../domain/add_wallet_state.dart';
import 'models/wallet_type.dart';

class AddWalletScreen extends StatelessWidget {
  const AddWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddWalletCubit(context.read<LocalWalletRepository>()),
      child: _AddWalletView(),
    );
  }
}

class _AddWalletView extends CommonBlocScaffoldWithButtonScreen
    with NameValidator, NumberValidator {
  _AddWalletView()
      : super(
          Get.localisation.addWalletTitle,
          icon: CommonIcons.check,
        );

  final TextEditingController _nameController = TextEditingController(text: "0");
  final TextEditingController _totalBalanceController = TextEditingController(text: "0");
  final TextEditingController _ownBalanceController = TextEditingController(text: "0");
  final TextEditingController _creditBalanceController = TextEditingController(text: "0");

  final _nameInputKey = GlobalKey<FormFieldState>();
  final _totalBalanceInputKey = GlobalKey<FormFieldState>();
  final _ownBalanceInputKey = GlobalKey<FormFieldState>();
  final _creditBalanceInputKey = GlobalKey<FormFieldState>();

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<AddWalletCubit, AddWalletState>(
      builder: (context, state) {
        _nameController.text = state.name ?? "";
        _totalBalanceController.text = state.totalBalance ?? "";
        _ownBalanceController.text = state.ownBalance ?? "";
        _creditBalanceController.text = state.creditBalance ?? "";

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Column(
              children: [
                CommonEditText(
                  widgetKey: _nameInputKey,
                  controller: _nameController,
                  hintText: Get.localisation.nameHint,
                  validator: validateName,
                  onChanged: (value) {
                    context.read<AddWalletCubit>().changeName(value);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(Get.localisation.addWalletTypeSelector),
                CommonToggleButtons(
                  onItemClick: (index) async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var type = WalletType.values[index];
                    context.read<AddWalletCubit>().changeWalletType(type);
                  },
                  isSelected:
                      WalletType.values.map((e) => e == state.walletType).toList(),
                  fillColor: CommonColors.defColor,
                  children: WalletType.values.map((e) {
                    return Text(e.name);
                  }).toList(),
                ),
                ..._balanceWidgetPart(context, state.walletType),
                _errorText(state.error),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onButtonPress(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    await context.read<AddWalletCubit>().onSaveWallet();
  }

  List<Widget> _balanceWidgetPart(BuildContext context, WalletType walletType) {
    switch (walletType) {
      case WalletType.debit:
        return [
          CommonEditText(
            widgetKey: _totalBalanceInputKey,
            validator: validateNumber,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _totalBalanceController,
            hintText: Get.localisation.addWalletTotalBalanceHint,
            onChanged: (value) {
              context.read<AddWalletCubit>().changeTotalBalance(value);
            },
          )
        ];
      case WalletType.credit:
        return [
          CommonEditText(
            widgetKey: _ownBalanceInputKey,
            validator: validateNumber,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _ownBalanceController,
            hintText: Get.localisation.addWalletOwnBalanceHint,
            onChanged: (value) {
              context.read<AddWalletCubit>().changeOwnBalance(value);
            },
          ),
          CommonEditText(
            widgetKey: _creditBalanceInputKey,
            validator: validateNumber,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _creditBalanceController,
            hintText: Get.localisation.addWalletCreditLimit,
            onChanged: (value) {
              context.read<AddWalletCubit>().changeCreditBalance(value);
            },
          ),
        ];
    }
  }

  Widget _errorText(String? errorText) {
    if (errorText != null) {
      return Text(
        errorText,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.start,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
