import 'package:flutter/material.dart';
import 'package:savings/utils/colors.dart';

class CustomThemedTextField extends StatefulWidget {
  final String hintText;
  final double fontSize;
  final int maxLength;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool centerText;
  final bool isDisabled;
  final FormFieldValidator<String> validator;

  CustomThemedTextField(
      {this.hintText,
      this.validator,
      this.fontSize,
      this.maxLength,
      this.textController,
      this.keyboardType = TextInputType.text,
      this.centerText,
      this.isDisabled = false});

  @override
  _CustomThemedTextFieldState createState() =>
      new _CustomThemedTextFieldState();
}

class _CustomThemedTextFieldState extends State<CustomThemedTextField> {
  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: buildTextFieldThemeData(widget.textController),
      child: new TextFormField(
        autocorrect: false,
        autofocus: false,
        maxLength: widget.maxLength != null ? widget.maxLength : null,
        keyboardType: widget.keyboardType,
        enabled: widget.isDisabled == true ? false : true,
        textAlign:
            widget.centerText == true ? TextAlign.center : TextAlign.left,
        decoration: new InputDecoration(
            hintText: widget.hintText,
            contentPadding: new EdgeInsets.only(bottom: 15.0),
            hintStyle: new TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
              fontFamily: "Proxima Nova",
            )),
        style: new TextStyle(
            color: primaryTextColor,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w700,
            fontFamily: "Proxima Nova"),
        controller: widget.textController,
        validator: widget.validator,
        onSaved: (input) {
          widget.textController.text = input;
        },
      ),
    );
  }

  ThemeData buildTextFieldThemeData(TextEditingController controller) {
    return new ThemeData(
      primaryColor:
          controller.text != "" ? primaryTextColor : lightHeadingsTextColor,
      hintColor:
          controller.text != "" ? primaryTextColor : lightHeadingsTextColor,
    );
  }
}
