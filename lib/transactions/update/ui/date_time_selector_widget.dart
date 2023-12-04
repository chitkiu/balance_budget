import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_toggle_buttons.dart';
import '../../../common/ui/common_ui_settings.dart';
import 'models/date_selection_type.dart';
import 'models/select_date_ui_model.dart';

class DateTimeSelectorWidget extends StatelessWidget {
  final Rx<SelectDayUIModel> date;
  final Function(DateSelectionType, DateTime?) onDateChanged;

  const DateTimeSelectorWidget(this.date, this.onDateChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          var selectedDate = date.value;

          return Column(
            children: [
              Text(Get.localisation
                  .dateString(CommonUI.dateFormatter.format(selectedDate.dateTime))),
              CommonToggleButtons(
                onItemClick: (index) async {
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
                          lastDate: DateTime(9999));
                      onDateChanged(type, newDate ?? selectedDate.dateTime);
                      break;
                  }
                },
                isSelected: [
                  selectedDate.isYesterday,
                  selectedDate.isToday,
                  !selectedDate.isYesterday && !selectedDate.isToday
                ],
                selectedBorderColor: Colors.green[700],
                selectedColor: Colors.white,
                fillColor: Colors.green[200]!,
                color: Colors.green[400],
                children: DateSelectionType.values.map((e) {
                  return Text(e.getTitle());
                }).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }
}
