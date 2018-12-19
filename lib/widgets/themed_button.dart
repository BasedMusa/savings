import 'package:flutter/material.dart';
import 'package:savings/utils/colors.dart';
import 'package:savings/utils/variables.dart';

class CustomThemedButton extends StatefulWidget {
  final bool isDisabled;
  final String text;
  final TextStyle textStyle;
  final double width;
  final double height;
  final GestureTapCallback onTap;
  final Color color;
  final bool invertedDesign;
  final bool shadowsVisible;

  CustomThemedButton(
      {@required this.text,
      this.isDisabled = false,
      this.textStyle,
      this.color = primaryThemeColor,
      this.onTap,
      this.invertedDesign = false,
      this.height,
      this.width,
      this.shadowsVisible = true});

  @override
  _CustomThemedButtonState createState() => new _CustomThemedButtonState();
}

class _CustomThemedButtonState extends State<CustomThemedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new InkWell(
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          padding: new EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          width: widget.width,
          height: widget.height,
          decoration: new BoxDecoration(
            gradient: widget.invertedDesign ? new LinearGradient(colors: appThemedGradientColors) : null,
              border: new Border.all(color: widget.isDisabled == true ? lightHeadingsTextColor : widget.color),
              borderRadius: new BorderRadius.circular(40.0),
              boxShadow: [
                new BoxShadow(
                    color: widget.shadowsVisible == true
                        ? primaryShadowColor
                        : primaryBackgroundColor,
                    offset: new Offset(0.0, 5.0),
                    blurRadius: 8.0,
                    spreadRadius: 1.0)
              ]),
          child: new Center(
            child: new Text(
              widget.text,
              style: widget.textStyle == null
                  ? new TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: widget.isDisabled == true ? lightHeadingsTextColor : widget.invertedDesign == true
                          ? Colors.white
                          : widget.color,
                    )
                  : widget.textStyle,
            ),
          ),
        ),
        onTap: widget.isDisabled != true ? widget.onTap : () {},
      ),
    );
  }
}
