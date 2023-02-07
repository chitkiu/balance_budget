import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppTranslate on GetInterface {
  AppLocalizations get localisation => AppLocalizations.of(context!)!;
}