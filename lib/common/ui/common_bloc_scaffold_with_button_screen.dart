import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

abstract class CommonBlocScaffoldWithButtonScreen extends StatelessWidget {
  final String title;
  final IconData? icon;

  const CommonBlocScaffoldWithButtonScreen(
    this.title, {
    super.key,
    this.icon,
  });

  Widget body(BuildContext context);

  void onButtonPress(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
              trailing: icon != null
                  ? GestureDetector(
                      onTap: () => onButtonPress(context),
                      child: Icon(icon),
                    )
                  : null);
        },
      ),
      body: SafeArea(
        child: body(context),
      ),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: icon != null
                ? FloatingActionButton(
                    onPressed: () => onButtonPress(context),
                    child: Icon(icon),
                  )
                : null);
      },
    );
  }
}
