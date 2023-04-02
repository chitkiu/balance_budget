import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/getx_extensions.dart';
import '../models/transaction_header_ui_model.dart';
import '../models/transaction_ui_model.dart';
import 'custom_tile.dart';
import 'transaction_item.dart';

class TransactionSectionHeaderWidget extends StatelessWidget {
  final TransactionHeaderUIModel model;
  final void Function(TransactionUIModel transaction) onItemClick;

  const TransactionSectionHeaderWidget(
      {required this.model, required this.onItemClick, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      defaultExpansion: true,
      titleBuilder: (onTap, isExpand) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(model.title, style: Theme.of(context).textTheme.titleSmall),
              Row(
                children: <Widget>[
                  RichText(
                      text: TextSpan(
                        text: Get.localisation.total,
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          TextSpan(
                              text: model.sum,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: model.sumColor
                              )
                          )
                        ]
                      )
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Icon(
                        isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
      children: model.transactions
          .map((e) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TransactionItem(e, onItemClick),
        ),
      ))
          .toList(),
    );
  }
}
