import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/ui/common_add_screen.dart';
import '../../../translator_extension.dart';
import '../domain/add_spend_controller.dart';

class AddSpendScreen extends CommonAddScreen<AddSpendController> {

  AddSpendScreen({super.key}) : super(Get.localisation.addSpendTitle);

  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        PlatformTextField(
          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
          controller: _sumController,
          material: (context, platform) {
            return MaterialTextFieldData(
                decoration: InputDecoration(
                    labelText: Get.localisation.addSpendSumHint
                )
            );
          },
          cupertino: (context, platform) {
            return CupertinoTextFieldData(
                placeholder: Get.localisation.addSpendSumHint
            );
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Get.localisation.addSpendCategoryHint),
            PlatformTextButton(
              onPressed: controller.onAddCategoryClick,
              child: Text(Get.localisation.addCategory),
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
            Text(Get.localisation.addSpendAccountHint),
            PlatformTextButton(
              onPressed: controller.onAddAccountClick,
              child: Text(Get.localisation.addAccount),
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
                    labelText: Get.localisation.addSpendCommentHint
                )
            );
          },
          cupertino: (context, platform) {
            return CupertinoTextFieldData(
                placeholder: Get.localisation.addSpendCommentHint
            );
          },
        ),
      ],
    );
  }

  @override
  void onSubmit() {
    controller.onSaveSpend(_sumController.text, _commentController.text);
  }

}