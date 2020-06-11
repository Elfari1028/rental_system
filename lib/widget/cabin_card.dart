import 'package:flutter/material.dart';

class CabinCard extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  Color color;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final BorderRadius borderRadius;
  double width;
  double height;
  BoxBorder border;
  final double elevation;
  final double hoverElevation;
  final double highlightElevation;
  final double disabledElevation;
  EdgeInsets padding;
  CabinCard({
    @required this.onPressed,
    @required this.child,
    this.color,
    this.hoverColor = Colors.white,
    this.highlightColor = Colors.transparent,
    this.splashColor = Colors.white30,
    this.borderRadius = BorderRadius.zero,
    this.hoverElevation = 7.0,
    this.elevation = 0,
    this.highlightElevation = 3.0,
    this.disabledElevation = 7.0,
    this.padding,
    this.border,
    this.height,
    this.width,
  }) {
    this.color ??= Colors.grey[200];
    this.border ??= Border();
    this.padding ??= EdgeInsets.all(20);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 20, 20),
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: border,
              color: color,
            ),
            child: RaisedButton(
              onPressed: this.onPressed,
              color: Colors.transparent,
              hoverColor: hoverColor,
              highlightColor: highlightColor,
              textColor: Colors.black,
              focusColor: Colors.white,
              disabledColor: Colors.white,
              hoverElevation: hoverElevation,
              elevation: elevation,
              highlightElevation: highlightElevation,
              disabledElevation: disabledElevation,
              splashColor: splashColor,
              padding: padding,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              child: this.child,
            )));
  }
}
