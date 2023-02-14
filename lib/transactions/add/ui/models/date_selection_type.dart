import 'package:get/get.dart';

import '../../../../common/getx_extensions.dart';

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
