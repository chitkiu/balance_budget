import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CommonEditText extends StatelessWidget {
  final Key? widgetKey;
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;

  const CommonEditText({Key? key, this.widgetKey, this.controller, this.hintText, this.validator, this.keyboardType, this.autovalidateMode, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformTextFormField(
      widgetKey: widgetKey,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      autovalidateMode: autovalidateMode,
      material: (context, platform) {
        return MaterialTextFormFieldData(
            decoration: InputDecoration(
                labelText: hintText
            ),
        );
      },
      cupertino: (context, platform) {
        return CupertinoTextFormFieldData(
          placeholder: hintText,
          decoration: kDefaultRoundedBorderDecoration,
          padding: EdgeInsets.zero,
        );
      },
      onChanged: onChanged,
    );
  }
}
