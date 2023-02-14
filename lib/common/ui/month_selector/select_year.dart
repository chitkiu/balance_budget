import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../getx_extensions.dart';
import 'selector_dialog_theme.dart';

class LocalSelectYear extends StatelessWidget {
  late final List<int> years = [];

  final Function(DateTime year) onHeaderChanged;

  final SelectorDialogTheme? yearStyle;

  final DateTime currentDateTime;

  late final BoxDecoration selectedDecoration;

  LocalSelectYear({
    super.key,
    required this.onHeaderChanged,
    this.yearStyle,
    required this.currentDateTime
  }) {
    int year = currentDateTime.year;
    for (var i = -50; i <= 25; i++) {
      years.add(year + i);
    }

    selectedDecoration = BoxDecoration(
      color: yearStyle?.selectedBackgroundColor,
      borderRadius: BorderRadius.circular(8),
    );
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    moveToCurrentYear();

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26)
        ),
        color: yearStyle?.backgroundColor,
      ),
      height: 380,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              Get.localisation.year_selector,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: yearStyle?.font,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                  controller: _scrollController,
                  itemCount: years.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 50
                  ),
                  itemBuilder: (context, index) => yearWidgetMaker(years[index], context)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget yearWidgetMaker(int year, context) {
    return GestureDetector(
      onTap: (() {
        Navigator.pop(context);
        onHeaderChanged.call(
          DateTime(
            year,
            currentDateTime.month,
          )
        );
      }),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: year == currentDateTime.year ? selectedDecoration : null,
          child: Text(
            '$year',
            style: TextStyle(
              fontSize: 16,
              color: year == currentDateTime.year ? yearStyle?.selectedTextColor : null,
              fontFamily: yearStyle?.font,
            ),
          ),
        ),
      ),
    );
  }

  double findSelectedYearOffset() {
    final size = _scrollController.position.maxScrollExtent / (years.length / 3);
    return size * (years.indexOf(currentDateTime.year)) / 3;
  }

  void moveToCurrentYear() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(findSelectedYearOffset());
      }
    });
  }
}