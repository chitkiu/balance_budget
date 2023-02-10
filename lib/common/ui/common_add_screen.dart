import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

abstract class CommonAddScreen<T> extends GetView<T> {
  final String title;
  const CommonAddScreen(this.title, {super.key});

  Widget body(BuildContext context);

  void onSubmit();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
              trailing: CupertinoButton(
                onPressed: onSubmit,
                child: const Icon(CupertinoIcons.checkmark),
              )
          );
        },
      ),
      body: body(context),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
              onPressed: onSubmit,
              child: const Icon(Icons.check),
            )
        );
      },
    );
  }

}