import 'package:flutter/material.dart';

import '../../../../common/ui/common_icons.dart';
import '../models/transaction_ui_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionUIModel transaction;
  final void Function(TransactionUIModel transaction) onItemClick;

  const TransactionItem(this.transaction, this.onItemClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onItemClick(transaction),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: CircleAvatar(
              child: Icon(Icons.no_transfer),
              backgroundColor: Colors.grey.withOpacity(0.3),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.categoryName,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  _subtitle(transaction),
                  if (transaction.comment != null)
                    _additionalInfo(transaction.comment!, CommonIcons.note)
                ],
              )
          ),
          SizedBox(
            width: 12,
          ),
          Text(transaction.sum,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: transaction.sumColor))
        ],
      ),
    );
  }

  Widget _subtitle(TransactionUIModel model) {
    String subtitleText;
    if (model is TransferTransactionUIModel) {
      subtitleText = "${model.fromAccountName} => ${model.toAccountName}";
    } else {
      subtitleText = model.accountName;
    }

    return _additionalInfo(subtitleText, CommonIcons.wallet);
  }

  Widget _additionalInfo(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }
}
