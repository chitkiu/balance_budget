import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../translator_extension.dart';
import '../domain/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(Get.localisation.settingsTabName),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return ListView(
      children: [
        PlatformElevatedButton(
          onPressed: controller.onManageAccountsClick,
          child: Text(Get.localisation.manageAccountsButtonText),
        ),
        PlatformElevatedButton(
          onPressed: controller.onManageCategoriesClick,
          child: Text(Get.localisation.manageCategoriesButtonText),
        ),
      ],
    );
  }

}