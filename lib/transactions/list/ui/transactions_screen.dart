import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../domain/transactions_controller.dart';
import 'cupertino_transactions_widget.dart';
import 'material_transactions_widget.dart';

class TransactionsScreen extends GetView<TransactionsController> {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      cupertino: (context, platform) =>
          CupertinoTransactionsWidget(controller: controller),
      material: (context, platform) => MaterialTransactionsWidget(controller: controller),
    );
  }
}
