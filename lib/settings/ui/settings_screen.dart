import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../common/getx_extensions.dart';
import '../../common/ui/common_ui_settings.dart';
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
          onPressed: controller.onManageCategoriesClick,
          child: Text(Get.localisation.manageCategoriesButtonText),
        ),
        PlatformElevatedButton(
          child: Text(Get.localisation.sign_out),
          onPressed: () async {
            await confirmBeforeActionDialog(
              () async {
                FirebaseUIAuth.signOut(
                  context: context,
                );
              },
              title: Get.localisation.sign_out,
              subTitle: Get.localisation.sign_out_confirmation_subtitle,
              confirmAction: Get.localisation.yes,
              cancelAction: Get.localisation.no,
            );
          },
        ),
      ],
    );
  }

}