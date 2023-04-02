import 'package:get/get.dart';

import '../../common/domain/models/deletable_bindings.dart';
import '../../common/getx_extensions.dart';
import 'settings_controller.dart';

class SettingsBinding extends DeletableBindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
  }

  @override
  void delete() {
    Get.deleteIfExist<SettingsController>();
  }
}