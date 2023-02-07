import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import 'home_screen/ui/home_screen.dart';

void main() async {
  runApp(const MyApp());
}

//TODO Add theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (isMaterial(context)) {
      return GetMaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      );
    } else {
      return GetCupertinoApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      );
    }
  }
}
