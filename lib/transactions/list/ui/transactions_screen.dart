import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/getx_extensions.dart';
import '../../../common/ui/common_icons.dart';
import '../domain/models/transactions_filter_date.dart';
import '../domain/transactions_controller.dart';
import 'items/transaction_item.dart';
import 'models/transaction_header_ui_model.dart';
import 'models/transaction_list_ui_model.dart';
import 'models/transaction_ui_model.dart';

const double _kDateInfoHeights = 24;

class TransactionsScreen extends GetView<TransactionsController> {
  final Rx<TransactionsFilterDate> _currentDate = TransactionsFilterDate(
          start: DateTime(DateTime.now().year, DateTime.now().month, 1),
          end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0))
      .obs;

  TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      cupertino: (context, platform) {
        return CupertinoPageScaffold(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: GestureDetector(
                  onTap: () => _showDatePickerDialog(context),
                  child: Obx(() => Text(_shortFormatCurrentSelectedDate(_currentDate.value))),
                ),
                middle: Text(Get.localisation.transactionsTabName),
                trailing: CupertinoButton(
                  onPressed: () => controller.addTransaction(),
                  child: Icon(CommonIcons.add),
                ),
              ),
              _body(true),
            ],
          ),
        );
      },
      material: (context, platform) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: kToolbarHeight + _kDateInfoHeights,
                title: Text(Get.localisation.transactionsTabName),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    width: MediaQuery.of(context).size.width,
                    height: kToolbarHeight + _kDateInfoHeights,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        NavigationToolbar.kMiddleSpacing,
                        kToolbarHeight + _kDateInfoHeights,
                        0,
                        0),
                    child: GestureDetector(
                      onTap: () => _showDatePickerDialog(context),
                      child: Obx(() {
                        var textStyle = Theme.of(context).textTheme.titleMedium;
                        return Text(
                          _formatCurrentSelectedDate(_currentDate.value),
                          style: textStyle,
                        );
                      }),
                    ),
                  ),
                ),
              ),
              _body(false)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => controller.addTransaction(),
            child: Icon(CommonIcons.add),
          ),
        );
      },
    );
  }

  Future<void> _showDatePickerDialog(BuildContext context) async {
    var result = (await showCalendarDatePicker2Dialog(
            context: context,
            config: CalendarDatePicker2WithActionButtonsConfig(
              calendarType: CalendarDatePicker2Type.range,
              firstDayOfWeek: DateTime.monday,
            ),
            dialogSize: const Size(325, 400),
            value: [_currentDate.value.start, _currentDate.value.end]))
        ?.whereType<DateTime>()
        .toList();

    if (result != null) {
      if (result.length == 1) {
        _currentDate.value = TransactionsFilterDate(
          start: result.first,
          end: result.first,
        );
      } else if (result.length == 2) {
        _currentDate.value = TransactionsFilterDate(
          start: result.first,
          end: result[1],
        );
      }
    }

    debugPrint("result $result");
  }

  Widget _body(bool addPaddingToBottom) {
    return Obx(() {
      return StreamBuilder(
        stream: controller.getItemsFromDayRange(_currentDate.value),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data?.isEmpty != false) {
            return SliverFillRemaining(
              child: Center(
                child: Text(Get.localisation.noTransactions),
              ),
            );
          }
          return _transactionsList(snapshot.data!, addPaddingToBottom);
        },
      );
    });
  }

  Widget _transactionsList(List<TransactionListUIModel> transactions, bool addPaddingToBottom) {
    int length = transactions.length * 2 - 1;
    if (addPaddingToBottom) {
      length += 1;
    }
    //TODO Improve UI
    return SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            if (index == length - 1 && addPaddingToBottom) {
              return const SizedBox(height: kMinInteractiveDimensionCupertino * 2);
            }
            final int itemIndex = index ~/ 2;
            if (index.isEven) {
              var item = transactions[itemIndex];
              Widget widget;
              if (item is TransactionHeaderUIModel) {
                widget = Text(
                  item.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall,
                );
              } else if (item is TransactionUIModel) {
                widget = TransactionItem(item, controller.onItemClick);
              } else {
                widget = Container();
              }

              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: widget,
              );
            }
            return const Divider();
          },
          semanticIndexCallback: (Widget widget, int localIndex) {
            if (localIndex.isEven) {
              return localIndex ~/ 2;
            }
            return null;
          },
          childCount: length,
        )
    );
  }

  final DateFormat _dateFormat = DateFormat("dd MMM");

  String _formatCurrentSelectedDate(TransactionsFilterDate date) {
    return Get.localisation
        .selected_dates(_dateFormat.format(date.start), _dateFormat.format(date.end));
  }
  String _shortFormatCurrentSelectedDate(TransactionsFilterDate date) {
    return "${_dateFormat.format(date.start)} - ${_dateFormat.format(date.end)}";
  }
}
