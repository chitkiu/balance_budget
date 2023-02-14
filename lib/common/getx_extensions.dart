import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

extension GetxExtension on GetInterface {
  Future<void> deleteIfExist<T>({bool force = false}) {
    if (isRegistered<T>()) {
      return delete<T>(force: force);
    } else {
      return Future(() {});
    }
  }

  AppLocalizations get localisation => AppLocalizations.of(context!)!;
}