import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../getx_extensions.dart';
import 'selector_dialog_theme.dart';

DateFormat _format = DateFormat('MMMM');
final List<String> _months = List.generate(
    DateTime.monthsPerYear,
        (index) => _format.format(DateTime(1, index+1))
);

class LocalSelectMonth extends StatelessWidget {
  final Function(DateTime selectedMonth) onHeaderChanged;

  final SelectorDialogTheme? monthStyle;

  final DateTime currentDate;

  late final BoxDecoration selectedDecoration;

  LocalSelectMonth({
    super.key,
    required this.onHeaderChanged,
    this.monthStyle,
    required this.currentDate
  }) {
    selectedDecoration = BoxDecoration(
      color: monthStyle?.selectedBackgroundColor,
      borderRadius: BorderRadius.circular(8),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26)
        ),
        color: monthStyle?.backgroundColor,
      ),
      height: 380,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              Get.localisation.month_selector,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: monthStyle?.font,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(color: Colors.black12, width: 0.2),
                        verticalInside: BorderSide(color: Colors.black12, width: 0.2),
                      ),
                      children: monthsWidgetMaker(context),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TableRow> monthsWidgetMaker(context) {
    List<TableRow> monthsWidget = [];
    for (var i = 0; i < 4; i++) {
      monthsWidget.add(TableRow(children: _buildRowCells(context, i)));
    }

    return monthsWidget;
  }

  List<Widget> _buildRowCells(BuildContext context, int rowIndex) {
    List<TableCell> widgets = [];
    for (var j = 0; j < 3; j++) {
      final int mMonth = (rowIndex * 3) + j + 1;
      widgets.add(
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: GestureDetector(
            onTap: (() {
              Navigator.pop(context);
              onHeaderChanged.call(
                  DateTime(
                    currentDate.year,
                    mMonth,
                  )
              );
            }),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: mMonth == currentDate.month ? selectedDecoration : null,
              child: Center(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      _months[(rowIndex * 3) + j].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: mMonth == currentDate.month
                            ? monthStyle?.selectedTextColor
                            : null,
                        fontFamily: monthStyle?.font,
                      ),
                      maxLines: 1,
                    ),
                  )),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}