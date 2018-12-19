import 'package:flutter/material.dart';
import 'package:savings/utils/colors.dart';

class CustomThemedText extends StatefulWidget {
  final String text;
  final Color color;
  final double letterSpacing;
  final double fontSize;
  final bool bold;

  CustomThemedText(
      {@required this.text,
      this.bold = true,
      this.color = primaryTextColor,
      this.letterSpacing,
      this.fontSize = 25.0});

  @override
  _CustomThemedTextState createState() => new _CustomThemedTextState();
}

class _CustomThemedTextState extends State<CustomThemedText> {
  @override
  Widget build(BuildContext context) {
    return new Text(
      widget.text,
      style: new TextStyle(
          fontWeight: widget.bold == true ? FontWeight.w700 : FontWeight.w500,
          fontSize: widget.fontSize,
          color: widget.color,
          letterSpacing: widget.letterSpacing,
          fontFamily: "Proxima Nova"),
    );
  }
}
