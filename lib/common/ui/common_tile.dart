import 'package:flutter/material.dart';

const Color _defaultIconColor = Color.fromARGB(77, 158, 158, 158);

class CommonTile extends StatelessWidget {
  final String? text;
  final Widget? textWidget;
  final String? secondText;
  final Widget? secondTextWidget;
  final IconData icon;
  final Color iconColor;
  final Color? secondTextColor;
  final Widget? additionalTextWidget;
  final Widget? tailing;

  const CommonTile({
    super.key,
    this.text,
    this.textWidget,
    this.secondText,
    this.secondTextWidget,
    required this.icon,
    this.iconColor = _defaultIconColor,
    this.secondTextColor,
    this.additionalTextWidget,
    this.tailing,
  })  : assert(text != null || textWidget != null);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(
          child: CircleAvatar(
            backgroundColor: iconColor,
            child: Icon(icon),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (textWidget != null)
              textWidget!
            else
              Text(text!, style: textTheme.titleSmall),
            if (secondTextWidget != null)
              secondTextWidget!
            else if(secondText != null)
              Text(secondText!,
                  style: textTheme.titleMedium?.copyWith(
                    color: secondTextColor,
                  )),
            if (additionalTextWidget != null) additionalTextWidget!
          ],
        )),
        if (tailing != null)
          const SizedBox(
            width: 12,
          ),
        if (tailing != null) tailing!
      ],
    );
  }
}
