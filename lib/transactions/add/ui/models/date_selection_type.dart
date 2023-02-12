import 'package:balance_budget/translator_extension.dart';
import 'package:get/get.dart';

enum DateSelectionType {
  yesterday,
  today,
  customDate;
}

extension DateNameType on DateSelectionType {
  String getTitle() {
    switch (this) {
      case DateSelectionType.yesterday:
        return Get.localisation.yesterday;
      case DateSelectionType.today:
        return Get.localisation.today;
      case DateSelectionType.customDate:
        return Get.localisation.customDate;
    }
  }
}
