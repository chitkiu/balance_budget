import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/ui/common_scaffold_with_button_screen.dart';
import '../../../translator_extension.dart';
import '../domain/add_transaction_controller.dart';

class AddTransactionScreen extends CommonScaffoldWithButtonScreen<AddTransactionController> {

  AddTransactionScreen({super.key}) : super(Get.localisation.addTransactionTitle);

  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PlatformTextField(
            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            controller: _sumController,
            material: (context, platform) {
              return MaterialTextFieldData(
                  decoration: InputDecoration(
                      labelText: Get.localisation.addTransactionSumHint
                  )
              );
            },
            cupertino: (context, platform) {
              return CupertinoTextFieldData(
                  placeholder: Get.localisation.addTransactionSumHint
              );
            },
          ),

          const SizedBox(height: 8,),
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
                      labelText: Get.localisation.addTransactionCommentHint
                  )
              );
            },
            cupertino: (context, platform) {
              return CupertinoTextFieldData(
                  placeholder: Get.localisation.addTransactionCommentHint
              );
            },
          ),

          //TODO Split ios and android - for ios use single picker, for android use split picker
          const SizedBox(
            height: 8,
          ),
          Obx(() {
            var selectedDate = controller.selectedDate.value;

            return Column(
              children: [
                Text("Selected date: ${selectedDate.dateTime.year}/${selectedDate.dateTime
                    .month}/${selectedDate.dateTime.day}"),
                ToggleButtons(
                  onPressed: (index) async {
                    switch (index) {
                      case 0:
                        controller.selectYesterday();
                        break;
                      case 1:
                        controller.selectToday();
                        break;
                      case 2:
                        var newDate = await showPlatformDatePicker(
                            context: context,
                            initialDate: selectedDate.dateTime,
                            firstDate: DateTime(1),
                            lastDate: DateTime(9999)
                        );
                        controller.selectCustomDay(newDate ?? selectedDate.dateTime);
                        break;
                    }
                  },
                  isSelected: [
                    selectedDate.isYesterday,
                    selectedDate.isToday,
                    !selectedDate.isYesterday && !selectedDate.isToday
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.green[700],
                  selectedColor: Colors.white,
                  fillColor: Colors.green[200],
                  color: Colors.green[400],
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  children: const [
                    Text("Yesterday"),
                    Text("Today"),
                    Text("Custom date")
                  ],
                )
              ],
            );
          }),
          Obx(() {
            var selectedTime = controller.selectedTime.value;

            return PlatformTextButton(
              onPressed: () async {
                if (Platform.isAndroid) {
                  var newTime = await showTimePicker(
                    context: Get.overlayContext!,
                    initialTime: TimeOfDay(
                        hour: selectedTime.hour, minute: selectedTime.minute),
                  );
                  controller.selectedTime.value = newTime ?? selectedTime;
                } else if (Platform.isIOS) {
                  _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: DateTime(2023, 1, 1, selectedTime.hour, selectedTime.minute),
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newTime) {
                        controller.selectedTime.value = TimeOfDay(hour: newTime.hour,
                            minute: newTime.minute);
                      },
                    ),
                  );
                }
              },
              child: Text("Selected time: ${selectedTime.hour}:${selectedTime.minute}"),
            );
          }),
        ],
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: Get.overlayContext!,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  @override
  void onButtonPress() {
    controller.onSaveTransaction(_sumController.text, _commentController.text);
  }

}