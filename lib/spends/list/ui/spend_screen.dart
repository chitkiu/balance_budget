import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../translator_extension.dart';
import '../domain/spends_controller.dart';
import 'models/spend_ui_model.dart';

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
            var grouped = spends[index];
            return Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(grouped.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 8,
                ),
                _spendItems(grouped.spends),
              ],
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

  Widget _spendItems(List<SpendUIModel> spends) {
    return Column(
      children: spends.map(_spendItem).toList(),
    );
  }

  Widget _spendItem(SpendUIModel spend) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(spend.categoryName,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
                spend.sum, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        Text(spend.time),
        if (spend.comment != null) Text("Comment: ${spend.comment}"),
      ],
    );
  }
}
