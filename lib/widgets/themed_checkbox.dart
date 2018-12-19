import 'package:flutter/material.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/variables.dart';

class CustomThemedCheckbox extends StatefulWidget {
  final double size;
  final bool value;
  final GestureTapCallback onChanged;

  CustomThemedCheckbox({this.size = 10.0, this.onChanged, this.value = true});

  @override
  _CustomThemedCheckboxState createState() => new _CustomThemedCheckboxState();
}

class _CustomThemedCheckboxState extends State<CustomThemedCheckbox> {
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: widget.onChanged,
      child: new Container(
        height: widget.size,
        width: widget.size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          gradient: widget.value == true ? new LinearGradient(colors: appThemedGradientColors,) : null,
          border: new Border.all(
            color: widget.value == true ? primaryThemeColor : primaryTextColor,
            width: widget.value == true ? 0.0 : 1.5,
          )
        ),
        child: new Center(
            child: new Icon(
          Icons.remove,
          size: widget.size,
          color: primaryBackgroundColor,
        )),
      ),
    );
  }
}
