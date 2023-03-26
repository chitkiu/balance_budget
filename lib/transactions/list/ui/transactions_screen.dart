import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../../../common/ui/custom_calendar/calendar.dart';
import '../../../common/ui/custom_calendar/calendar_controller.dart';
import '../domain/transactions_controller.dart';
import 'items/transaction_item.dart';

class TransactionsScreen extends GetView<TransactionsController> {

  final CalendarController _calendarController = CalendarController(
    DateTime.now(),
    minDate: DateTime(1990),
    maxDate: DateTime(2050),
  );

  TransactionsScreen({super.key});

  Widget _calendar() {
    return Calendar2(
      controller: _calendarController,
    );
  }

  Widget _pageBody() {
    return PageView.builder(
      itemCount: _calendarController.totalDays,
      controller: _calendarController.pageController,
      onPageChanged: (index) {
        _calendarController.changeIndex(index);
      },
      itemBuilder: (_, index) {
        return _perDayContent(
            _calendarController.getDateFromIndex(index)
        );
      },
    );
  }

  Widget _perDayContent(DateTime date) {
    return Obx(() {
      var items = controller.getItemsFromDay(date);
      if (items.isEmpty) {
        return Center(
          child: Text(Get.localisation.noTransactions),
        );
      }
      return ListView.separated(
          itemBuilder: (context, index) {
            return TransactionItem(items[index], controller.onItemClick);
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: items.length
      );
    });
  }

  void _onButtonPress() {
    controller.addTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      cupertino: (context, platform) {
        return CupertinoPageScaffoldData(
          navigationBar: CupertinoNavigationBar(
            trailing: CupertinoButton(
              onPressed: _onButtonPress,
              child: Icon(CommonIcons.add),
            ),
            middle: Text(Get.localisation.transactionsTabName),
          ),
          body: SafeArea(
            child: _cupertinoBody(),
          ),
        );
      },
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
              onPressed: _onButtonPress,
              child: Icon(CommonIcons.add),
            ),
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: kToolbarHeight + kCalendarMaterialHeight,
                    title: Text(Get.localisation.transactionsTabName),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.only(top: kToolbarHeight)),
                          _calendar(),
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: _pageBody(),
          )
        );
      },
    );
  }

  Widget _cupertinoBody() {
    return Column(
      children: [
        _calendar(),
        Expanded(
            child: _pageBody()
        ),
      ],
    );
  }
}
