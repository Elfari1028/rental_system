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
  CabinCard({
    @required this.onPressed,
    @required this.child,
    this.color,
    this.hoverColor = Colors.white,
    this.highlightColor = Colors.transparent,
    this.splashColor = Colors.white30,
    this.borderRadius = BorderRadius.zero,
    this.height,
    this.width,
  }) {
    this.color ??= Colors.grey[200];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 15, 15),
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: color,
            ),
            child: RaisedButton(
              onPressed: this.onPressed,
              color: Colors.transparent,
              hoverColor: hoverColor,
              highlightColor: highlightColor,
              focusColor: Colors.white,
              disabledColor: Colors.white,
              hoverElevation: 7.0,
              elevation: 0,
              highlightElevation: 3.0,
              disabledElevation: 7.0,
              splashColor: splashColor,
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              child: this.child,
            )));
  }
}
