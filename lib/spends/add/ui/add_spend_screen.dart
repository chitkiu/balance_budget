import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../translator_extension.dart';
import '../domain/add_spend_controller.dart';

class AddSpendScreen extends GetWidget<AddSpendController> {

  AddSpendScreen({super.key});

  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(Get.localisation.addSpendTitle),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
            trailing: CupertinoButton(
              child: const Icon(CupertinoIcons.checkmark),
              onPressed: () {
                controller.onSaveSpend(_sumController.text, _commentController.text);
              },
            )
          );
        },
      ),
      body: Column(
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
                onPressed: () {

                },
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
      ),
      material: (context, platform) {
        return MaterialScaffoldData(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.onSaveSpend(_sumController.text, _commentController.text);
            },
            child: const Icon(Icons.check),
          )
        );
      },
    );
  }

}