import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

abstract class CommonScaffoldWithButtonScreen<T> extends GetView<T> {
  final String title;
  final IconData icon;

  const CommonScaffoldWithButtonScreen(
    this.title, {
    super.key,
    required this.icon,
  });

  Widget body(BuildContext context);

  void onButtonPress();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
              trailing: GestureDetector(
                onTap: onButtonPress,
                child: Icon(icon),
              )
          );
        },
      ),
      body: SafeArea(
        child: body(context),
      ),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
              onPressed: onButtonPress,
              child: Icon(icon),
            )
        );
      },
    );
  }
}
