import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../common/ui/common_ui_settings.dart';
import '../domain/import_controller.dart';
import '../domain/models/column_types.dart';

class ImportScreen extends GetView<ImportController> {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Select import"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text("Column name:", style: TextStyle(color: Colors.black)),
              Spacer(),
              Text("Column type:", style: TextStyle(color: Colors.black))
            ],
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final columnName = controller.columnNames[index];

              return Row(
                children: [
                  Text(columnName),
                  Spacer(),
                  Material(
                    child: Obx(() {
                      return DropdownButton(
                        items: ColumnTypes.values.map((e) {
                          return DropdownMenuItem(
                            child: Text("${e.name}"),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (value) {
                          debugPrint("$value");
                          if (value != null) {
                            controller.items[index] = value;
                          }
                        },
                        value: controller.items[index],
                      );
                    }),
                  )
                ],
              );
            },
            itemCount: controller.columnNames.length,
          ),
          PlatformElevatedButton(
            onPressed: () async {
              final categories = controller.getAllCategories()?.toList();
              if (categories == null) {
                return;
              }
              final transferCategoryName = await showPlatformDialog(
                  context: context,
                  material: MaterialDialogData(
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Select transfer category"),
                        content: ListView.builder(
                          itemBuilder: (context, index) {
                            final item = categories[index];
                            return TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(item);
                                },
                                child: Text(item));
                          },
                          itemCount: categories.length,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop("");
                            },
                            child: Text("None"),
                          )
                        ],
                      );
                    },
                  ),
                  cupertino: CupertinoDialogData(
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text("Select transfer category"),
                        content: ListView.builder(
                          itemBuilder: (context, index) {
                            final item = categories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(item);
                              },
                              child: Text(item),
                            );
                          },
                          itemCount: categories.length,
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("None"),
                            onPressed: () {
                              Navigator.of(context).pop("");
                            },
                          )
                        ],
                      );
                    },
                  ));
              debugPrint("Transfer category: $transferCategoryName");
              if (transferCategoryName == null) {
                return;
              }
              await loadingDialogWhileExecution(context, () async {
                await controller.parseData(transferCategoryName);
              });
              Get.back();
            },
            child: Text("Save transactions"),
          ),
        ],
      ),
    );
  }
}
