import 'package:get/get.dart';

import '../generated/l10n.dart';

extension GetxExtension on GetInterface {
  Future<void> deleteIfExist<T>({bool force = false}) {
    if (isRegistered<T>()) {
      return delete<T>(force: force);
    } else {
      return Future(() {});
    }
  }

  S get localisation => S.of(context!);
}