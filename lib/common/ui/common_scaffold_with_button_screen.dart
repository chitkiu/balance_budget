import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

abstract class CommonScaffoldWithButtonScreen<T> extends GetView<T> {
  final String title;
  final IconData cupertinoIcon;
  final IconData materialIcon;

  const CommonScaffoldWithButtonScreen(this.title,
      {super.key,
      this.cupertinoIcon = CupertinoIcons.checkmark,
      this.materialIcon = Icons.check});

  Widget body(BuildContext context);

  void onButtonPress();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
              trailing: CupertinoButton(
                onPressed: onButtonPress,
                child: Icon(cupertinoIcon),
              )
          );
        },
      ),
      body: body(context),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
              onPressed: onButtonPress,
              child: Icon(materialIcon),
            )
        );
      },
    );
  }
}
