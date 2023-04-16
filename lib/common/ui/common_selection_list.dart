import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'common_icons.dart';

class SelectionListItem<T> {
  final String name;
  final bool isSelected;
  final T model;

  const SelectionListItem({required this.name, required this.isSelected, required this.model});
}

class CommonSelectionList<T> extends StatelessWidget {

  final Iterable<SelectionListItem<T>> items;
  final void Function(T model) onClick;

  const CommonSelectionList({super.key, required this.items, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items.map((item) {
          return PlatformTextButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              onClick(item.model);
            },
            child: Row(
              children: [
                Text(item.name),
                if (item.isSelected) Icon(CommonIcons.ok)
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
