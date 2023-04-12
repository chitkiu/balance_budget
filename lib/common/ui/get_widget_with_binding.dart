import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef ControllerCreator<S extends GetxController> = S Function();

abstract class GetWidgetWithBinding<Controller extends GetxController> extends StatelessWidget {
  final ControllerCreator<Controller> controllerCreator;

  const GetWidgetWithBinding({super.key, required this.controllerCreator});

  Widget view(BuildContext context, Controller controller);

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (controller) => view(context, controller),
      init: controllerCreator(),
    );
  }

}
