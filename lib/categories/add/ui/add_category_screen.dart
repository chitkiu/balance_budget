import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/domain/name_validator.dart';
import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_bloc_scaffold_with_button_screen.dart';
import '../../../common/ui/common_colors.dart';
import '../../../common/ui/common_edit_text.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/common_toggle_buttons.dart';
import '../../../common/ui/common_ui_settings.dart';
import '../../common/data/local_category_repository.dart';
import '../domain/add_category_cubit.dart';
import '../domain/add_category_state.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCategoryCubit(
        context.read<LocalCategoryRepository>(),
      ),
      child: _AddCategoryView(),
    );
  }
}

class _AddCategoryView extends CommonBlocScaffoldWithButtonScreen with NameValidator {
  _AddCategoryView()
      : super(
          Get.localisation.addCategoryTitle,
          icon: CommonIcons.check,
        );

  final _nameInputKey = GlobalKey<FormFieldState>();

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<AddCategoryCubit, NewCategoryState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CommonEditText(
                  widgetKey: _nameInputKey,
                  validator: validateName,
                  hintText: Get.localisation.nameHint,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    context.read<AddCategoryCubit>().changeName(value);
                  },
                ),

                const SizedBox(
                  height: 8,
                ),
                Text(Get.localisation.transactionTypeHint),
                CommonToggleButtons(
                    onItemClick: (index) async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      var type = TransactionType.canAddCategory[index];

                      context.read<AddCategoryCubit>().changeType(type);
                    },
                    isSelected: TransactionType.canAddCategory
                        .map((e) => e == state.type)
                        .toList(),
                    fillColor: _getBackgroundColorBySelectedType(state.type),
                    children: TransactionType.canAddCategory.map((e) {
                      return Text(e.name);
                    }).toList()),
                const SizedBox(
                  height: 8,
                ),
                //TODO Improve UI
                Row(
                  children: [
                    Text(Get.localisation.selected_category_icon),
                    Icon(state.icon ?? Icons.not_interested),
                    PlatformElevatedButton(
                      child: Text(Get.localisation.select_category_icon),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());

                        IconData? icon = await FlutterIconPicker.showIconPicker(context,
                            iconPackModes: [IconPack.custom],
                            customIconPack: CommonIcons.icons);

                        if (icon != null) {
                          context.read<AddCategoryCubit>().changeIcon(icon);
                        }
                      },
                    )
                  ],
                ),
                _errorText(state.error),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColorBySelectedType(TransactionType? type) {
    switch (type) {
      case TransactionType.expense:
        return CommonColors.expense;
      case TransactionType.income:
        return CommonColors.income;
      case TransactionType.transfer:
      case TransactionType.setInitialBalance:
      case null:
        return CommonColors.defColor;
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

  @override
  void onButtonPress(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_nameInputKey.currentState?.validate() == true) {
      await loadingDialogWhileExecution(
        context,
        () async {
          await context.read<AddCategoryCubit>().saveCategory();
        },
      );
    }
  }
}
