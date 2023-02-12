import 'package:balance_budget/transactions/add/ui/date_time_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../translator_extension.dart';
import '../domain/add_transaction_controller.dart';

class AddTransactionScreen
    extends CommonScaffoldWithButtonScreen<AddTransactionController> {
  AddTransactionScreen({super.key}) : super(Get.localisation.addTransactionTitle);

  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PlatformTextField(
            keyboardType:
                const TextInputType.numberWithOptions(signed: true, decimal: true),
            controller: _sumController,
            material: (context, platform) {
              return MaterialTextFieldData(
                  decoration:
                      InputDecoration(labelText: Get.localisation.addTransactionSumHint));
            },
            cupertino: (context, platform) {
              return CupertinoTextFieldData(
                  placeholder: Get.localisation.addTransactionSumHint);
            },
          ),

          const SizedBox(
            height: 8,
          ),
          Text(Get.localisation.transactionTypeHint),
          //TODO Make it cross-platform
          Material(
            child: Obx(() {
              return DropdownButton(
                items: TransactionType.values.map((e) {
                  return DropdownMenuItem<TransactionType>(
                    value: e,
                    child: Text(e.name),
                  );
                }).toList(),
                value: controller.selectedType.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedType.value = value;
                  }
                },
              );
            }),
          ),

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
                        if (element.isSelected)
                          const Icon(Icons.check) //TODO Cross-platform icon
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ),

          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Get.localisation.addTransactionAccountHint),
              PlatformTextButton(
                onPressed: controller.onManageAccountsClick,
                child: Text(Get.localisation.manageAccountsButtonText),
              )
            ],
          ),
          SizedBox(
            height: 50,
            child: Obx(() {
              return ListView(
                scrollDirection: Axis.horizontal,
                children: controller.accountList.map((element) {
                  return PlatformTextButton(
                    onPressed: () {
                      controller.selectAccount(element);
                    },
                    child: Row(
                      children: [
                        Text(element.title),
                        if (element.isSelected)
                          const Icon(Icons.check) //TODO Cross-platform icon
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ),

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
            controller.selectedTime,
            controller.selectDateByType,
            (time) {
              controller.selectedTime.value = time;
            },
          )
        ],
      ),
    );
  }

  @override
  void onButtonPress() {
    controller.onSaveTransaction(_sumController.text, _commentController.text);
  }
}
