import 'package:flutter/material.dart';

class BottomSheetHideIcon extends StatelessWidget {
  const BottomSheetHideIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: SizedBox(
        height: 4,
        width: 32,
        child: Container(
          decoration: BoxDecoration(
            //TODO Update color
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
