import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef BindingCreator<S extends Bindings> = S Function();

abstract class GetWidgetWithBinding<Binding extends Bindings, Controller> extends GetView<Controller> {
  final BindingCreator<Binding>? bindingCreator;

  const GetWidgetWithBinding({super.key, required this.bindingCreator});

  Widget view(BuildContext context);

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    _createBinding();
    return view(context);
  }

  void _createBinding() {
    Binding? binding = bindingCreator?.call();
    binding?.dependencies();
  }
}
