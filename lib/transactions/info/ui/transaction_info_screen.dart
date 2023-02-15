import 'package:balance_budget/common/ui/common_icons.dart';
import 'package:balance_budget/transactions/list/ui/models/transaction_ui_model.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TransactionInfoScreen extends StatefulWidget {
  final TransactionUIModel model;

  const TransactionInfoScreen(this.model, {Key? key}) : super(key: key);

  @override
  State<TransactionInfoScreen> createState() => _TransactionInfoScreenState();
}

class _TransactionInfoScreenState extends State<TransactionInfoScreen> {

  bool _isInEditMode = false;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Transaction info"),
        trailingActions: [
          GestureDetector(
            onTap: _changeEditMode,
            child: Icon(_isInEditMode ? CommonIcons.check : CommonIcons.edit),
          )
        ],
      ),
      body: Column(
        children: [
          Text("Sum:",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(widget.model.sum),
          Text("Category:",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(widget.model.categoryName),
          Text("Account:",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(widget.model.accountName),
          Text("Time:",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(widget.model.time),

        ],
      ),
    );
  }

  void _changeEditMode() {
    setState(() {
      _isInEditMode = !_isInEditMode;
    });
  }
}
