import 'package:flutter/material.dart';
import 'package:savings/utils/colors.dart';

class CustomThemedContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color backgroundColor;
  final double height;
  final double width;
  final double outerRadius;
  final LinearGradient gradient;

  CustomThemedContainer(
      {@required this.child, this.backgroundColor = Colors.white, this.outerRadius = 4.0, this.padding, this.margin, this.width, this.height, this.gradient});

  @override
  _CustomThemedContainerState createState() =>
      new _CustomThemedContainerState();
}

class _CustomThemedContainerState extends State<CustomThemedContainer> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: widget.padding,
      decoration: new BoxDecoration(
          color: widget.gradient == null ? widget.backgroundColor : null,
          gradient: widget.gradient,
          borderRadius: new BorderRadius.circular(widget.outerRadius),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: darkShadowColor,
              blurRadius: 5.0,
              offset: new Offset(0.0, 2.0),
              spreadRadius: 0.0,
            )
          ]),
      child: widget.child,
      margin: widget.margin,
      height: widget.height,
      width: widget.width,
    );
  }
}
