import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_ui_settings.dart';
import 'models/date_selection_type.dart';
import 'models/select_date_ui_model.dart';

//TODO Add ToggleButtons for cupertino
class DateTimeSelectorWidget extends PlatformWidgetBase<Widget, Widget> {
  final Rx<SelectDayUIModel> date;
  final Function(DateSelectionType, DateTime?) onDateChanged;

  const DateTimeSelectorWidget(this.date, this.onDateChanged, {super.key});

  @override
  Widget createCupertinoWidget(BuildContext context) {
    return Obx(() {
      var selectedDate = date.value.dateTime;
      return PlatformTextButton(
        child: Text(
          Get.localisation.fullDateTimeString(
              CommonUI.dateFormatter.format(selectedDate)
          )
        ),
        onPressed: () {
          _showCupertinoDialog(
            context,
            CupertinoDatePicker(
              initialDateTime: DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              onDateTimeChanged: (DateTime newTime) {
                onDateChanged(DateSelectionType.customDate, newTime);
              },
            ),
          );
        },
      );
    });
  }

  @override
  Widget createMaterialWidget(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          var selectedDate = date.value;

          return Column(
            children: [
              Text(
                  Get.localisation.dateString(
                      CommonUI.dateFormatter.format(selectedDate.dateTime)
                  )
              ),
              LayoutBuilder(
                builder: (buildContext, constraints) {
                  return ToggleButtons(
                    onPressed: (index) async {
                      var type = DateSelectionType.values[index];
                      switch (type) {
                        case DateSelectionType.yesterday:
                          onDateChanged(type, null);
                          break;
                        case DateSelectionType.today:
                          onDateChanged(type, null);
                          break;
                        case DateSelectionType.customDate:
                          var newDate = await showPlatformDatePicker(
                              context: context,
                              initialDate: selectedDate.dateTime,
                              firstDate: DateTime(1),
                              lastDate: DateTime(9999)
                          );
                          onDateChanged(type, newDate ?? selectedDate.dateTime);
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
                    constraints: BoxConstraints(
                      minHeight: 40.0,
                      minWidth: (constraints.maxWidth - 8 * 2) / 3,
                    ),
                    children: DateSelectionType.values.map((e) {
                      return Text(e.getTitle());
                    })
                        .toList(),
                  );
                },
              )
            ],
          );
        }),
      ],
    );
  }

  void _showCupertinoDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
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
}
