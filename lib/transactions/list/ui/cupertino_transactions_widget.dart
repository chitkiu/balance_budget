import 'package:balance_budget/transactions/list/domain/transactions_cubit.dart';
import 'package:balance_budget/transactions/list/domain/transactions_state.dart';
import 'package:balance_budget/transactions/list/ui/calendar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/transaction_item/models/transaction_header_ui_model.dart';
import '../domain/models/transactions_filter_date.dart';
import 'base_transactions_widget.dart';
import 'filter_popup/filter_dialog.dart';

//TODO Improve UI
class CupertinoTransactionsWidget extends BaseTransactionsWidget {
  const CupertinoTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(Get.localisation.transactionsTabName),
          trailing: GestureDetector(
            onTap: () {
              context.read<TransactionsCubit>().addTransaction(context);
            },
            child: Icon(CommonIcons.add),
          ),
        ),
        child: SafeArea(child: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            switch (state.status) {
              case TransactionsStatus.initial:
                return const SizedBox.shrink();
              case TransactionsStatus.loading:
                return Center(
                  child: PlatformCircularProgressIndicator(),
                );
              case TransactionsStatus.success:
                return _transactionsWidget(context, state);
              case TransactionsStatus.failure:
                return Center(
                  child: Text("Error:\n${state.error}"),
                );
            }
          },
        )));
  }

  Widget _transactionsWidget(BuildContext context, TransactionsState state) {
    return Column(
      children: [
        _CupertinoFilterWidget(state.date ??
            TransactionsFilterDate(start: DateTime.now(), end: DateTime.now())),
        Expanded(
            child: _transactionsList(context, state.model?.transactions ?? List.empty()))
      ],
    );
  }

  Widget _transactionsList(
      BuildContext context, List<TransactionHeaderUIModel> transactions) {
    if (transactions.isNotEmpty) {
      return ListView(
        children: transactions.map((item) => transactionWidget(context, item)).toList(),
      );
    } else {
      return Center(
        child: Text(Get.localisation.noTransactions),
      );
    }
  }
}

class _CupertinoFilterWidget extends StatelessWidget {
  final TransactionsFilterDate date;

  const _CupertinoFilterWidget(this.date);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 3),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TransactionsCalendarButton(date),
              ),
              GestureDetector(
                onTap: () => showFilterDialog(context: context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: <Widget>[
                      Text(
                        Get.localisation.filter,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          CommonIcons.filter,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.black,
        )
      ],
    );
  }
}
