import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import 'models/date_selection_type.dart';
import 'models/select_date_ui_model.dart';

class DateTimeSelectorWidget extends PlatformWidgetBase<Widget, Widget> {
  final Rx<SelectDayUIModel> date;
  final Rx<TimeOfDay> time;
  final Function(DateSelectionType, DateTime?) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;

  const DateTimeSelectorWidget(
      this.date, this.time, this.onDateChanged, this.onTimeChanged,
      {super.key});

  @override
  Widget createCupertinoWidget(BuildContext context) {
    return Obx(() {
      var selectedDate = date.value.dateTime;
      var selectedTime = time.value;
      return PlatformTextButton(
        child: Text(
          Get.localisation.fullDateTimeString(
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
              selectedDate.month,
              selectedDate.year
          )
        ),
        onPressed: () {
          _showCupertinoDialog(
            context,
            CupertinoDatePicker(
              initialDateTime: DateTime(selectedDate.year, selectedDate.month,
                  selectedDate.day, selectedTime.hour, selectedTime.minute),
              mode: CupertinoDatePickerMode.dateAndTime,
              use24hFormat: true,
              onDateTimeChanged: (DateTime newTime) {
                onDateChanged(DateSelectionType.customDate, newTime);
                onTimeChanged(TimeOfDay(hour: newTime.hour, minute: newTime.minute));
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
                      selectedDate.dateTime.day,
                      selectedDate.dateTime.month,
                      selectedDate.dateTime.year
                  )
              ),
              ToggleButtons(
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
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                children: DateSelectionType.values.map((e) {
                  return Text(e.getTitle());
                })
                    .toList(),
              )
            ],
          );
        }),
        Obx(() {
          var selectedTime = time.value;

          return PlatformTextButton(
            onPressed: () async {
              var newTime = await showTimePicker(
                context: Get.overlayContext!,
                initialTime: TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
              );
              onTimeChanged(newTime ?? selectedTime);
            },
            child: Text(
              Get.localisation.timeString(
                  selectedTime.hour,
                  selectedTime.minute
              )
            ),
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
