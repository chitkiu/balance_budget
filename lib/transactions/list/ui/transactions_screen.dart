import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'cupertino_transactions_widget.dart';
import 'material_transactions_widget.dart';

class TransactionsScreen extends PlatformWidgetBase {
  const TransactionsScreen({super.key});

  @override
  Widget createCupertinoWidget(BuildContext context) => CupertinoTransactionsWidget();

  @override
  Widget createMaterialWidget(BuildContext context) => MaterialTransactionsWidget();
}
