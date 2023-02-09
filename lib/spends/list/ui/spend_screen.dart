import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../translator_extension.dart';
import '../domain/spends_controller.dart';

class SpendScreen extends GetWidget<SpendsController> {
  const SpendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(Get.localisation.spendsTabName),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
            trailing: CupertinoButton(
              child: const Icon(CupertinoIcons.add),
              onPressed: () {
                controller.addSpend();
              },
            )
          );
        },
      ),
      body: Obx(() {
        var spends = controller.spends;
        return ListView.builder(
          itemBuilder: (context, index) {
            var item = spends[index];
            return ListTile(
              title: Text(Get.localisation.spendSum(item.sum)),
              subtitle: Text(Get.localisation.spendCategory(item.categoryName)),
            );
          },
          itemCount: spends.length,
        );
      }),
      material: (context, platform) {
        return MaterialScaffoldData(
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                controller.addSpend();
              },
            child: const Icon(Icons.add),
          )
        );
      },
    );
  }
}
