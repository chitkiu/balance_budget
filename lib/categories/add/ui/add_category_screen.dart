import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../translator_extension.dart';
import '../domain/add_category_controller.dart';

class AddCategoryScreen extends GetView<AddCategoryController> {
  AddCategoryScreen({super.key});

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(Get.localisation.addCategory),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
              trailing: CupertinoButton(
                child: const Icon(CupertinoIcons.checkmark),
                onPressed: () {
                  controller.onSaveCategory(_nameController.text);
                },
              )
          );
        },
      ),
      body: Column(
        children: [
          PlatformTextField(
            controller: _nameController,
            material: (context, platform) {
              return MaterialTextFieldData(
                  decoration: InputDecoration(
                      labelText: Get.localisation.nameHint
                  )
              );
            },
            cupertino: (context, platform) {
              return CupertinoTextFieldData(
                placeholder: Get.localisation.nameHint
              );
            },
          ),
        ],
      ),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                controller.onSaveCategory(_nameController.text);
              },
              child: const Icon(Icons.check),
            )
        );
      },
    );
  }

}