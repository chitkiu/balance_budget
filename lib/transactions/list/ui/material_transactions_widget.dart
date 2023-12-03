import 'package:balance_budget/common/ui/transaction_item/models/complex_transactions_ui_model.dart';
import 'package:balance_budget/transactions/list/domain/transactions_cubit.dart';
import 'package:balance_budget/transactions/list/domain/transactions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import 'base_transactions_widget.dart';
import 'filter_popup/filter_dialog.dart';

//TODO Improve UI
class MaterialTransactionsWidget extends BaseTransactionsWidget {
  MaterialTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.localisation.transactionsTabName),
        actions: [
          BlocBuilder<TransactionsCubit, TransactionsState>(
              builder: (context, state) {
                return calendarButton(context, state.date);
              },
          ),
        ],
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          switch (state.status) {
            case TransactionsStatus.initial:
              return const SizedBox.shrink();
            case TransactionsStatus.loading:
              return Center(
                child: PlatformCircularProgressIndicator(),
              );
            case TransactionsStatus.success:
              return _transactionsList(context, state.model);
            case TransactionsStatus.failure:
              return Center(
                child: Text("Error:\n${state.error}"),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TransactionsCubit>().addTransaction(context);
        },
        child: Icon(CommonIcons.add),
      ),
    );
  }

  Widget _searchBar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 64,
          child: TextField(
              cursorColor: Colors.grey,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.search),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.only(top: 8),
              )),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _transactionsList(
      BuildContext context, ComplexTransactionsUIModel? model) {
    if (model?.transactions.isEmpty == true) {
      return Center(
        child: Text(Get.localisation.noTransactions),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return _searchBar();
          }, childCount: 1),
        ),
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: _FilterHeader(model?.transactionCount ?? 0),
        ),
        SliverList(
            delegate: SliverChildListDelegate.fixed(
          model?.transactions
                  .map((item) => mapTransactionToUI(context, item))
                  .toList() ??
              [],
        ))
      ],
    );
  }
}

class _FilterHeader extends SliverPersistentHeaderDelegate {
  final int transactionCount;

  _FilterHeader(this.transactionCount);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 3),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text(Get.localisation.transactions(transactionCount)),
                  ),
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
          const Divider(height: 1),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is _FilterHeader
        ? oldDelegate.transactionCount != transactionCount
        : true;
  }
}
