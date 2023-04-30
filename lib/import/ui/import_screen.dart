import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

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
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return const Dialog(
                      child: CircularProgressIndicator(),
                    );
                  }
              );
              await controller.parseData();
              Navigator.of(context).pop();
              Get.back();
            },
            child: Text("Save transactions"),
          ),
        ],
      ),
    );
  }
}
