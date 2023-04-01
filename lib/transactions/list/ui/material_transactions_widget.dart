import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import 'base_transactions_widget.dart';
import 'models/transaction_list_ui_model.dart';

class MaterialTransactionsWidget extends BaseTransactionsWidget {
  MaterialTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO Add translation
        title: Text("Resent"),
        actions: [
          calendarButton(context),
        ],
      ),
      body: controller.obx(
        (transactions) => _transactionsList(context, transactions),
        onLoading: const Center(
          child: CircularProgressIndicator(),
        ),
        onEmpty: Center(
          child: Text(Get.localisation.noTransactions),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addTransaction,
        child: Icon(CommonIcons.add),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.green,
      height: 64,
      child: PlatformTextField(
        cursorColor: Colors.grey,
        textAlign: TextAlign.start,
        material: (context, platform) => MaterialTextFieldData(
            decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.search),
          ),
          isDense: true,
          contentPadding: EdgeInsets.only(top: 8),
        )),
      ),
    );
  }

  Widget _transactionsList(
      BuildContext context, List<TransactionListUIModel>? transactions) {
    return Column(
      children: <Widget>[
        Expanded(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return _searchBar();
                  }, childCount: 1),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: _FilterHeader(),
                ),
              ];
            },
            body: SafeArea(
              bottom: false,
              child: ListView(
                children: transactions
                        ?.map((item) => mapTransactionToUI(context, item))
                        .toList() ??
                    [],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _FilterHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  //TODO replace by translation
                  '100 transactions',
                ),
              ),
            ),
            GestureDetector(
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
    );
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
