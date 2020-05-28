import 'dart:ui';

import 'package:cabin/widget/adaptive.dart';
import 'package:fluid_layout/fluid_layout.dart';

import 'cabin_nav_bar.dart';
import 'package:flutter/material.dart';

class CabinScaffold extends StatefulWidget {
  final CabinNavBar navBar;
  final Widget banner;
  final Widget body;
  final Widget side;
  final bool adaptivePage;
  CabinScaffold({
    @required this.navBar,
    this.banner,
    this.side,
    @required this.body,
    this.adaptivePage = true,
  });
  createState() => CabinScaffoldState();
}

class CabinScaffoldState extends State<CabinScaffold> {
  double _screenWidth;
  double _screenHeight;

  bool hasSide = false;
  bool hasBanner = false;
  @override
  void initState() {
    hasSide = widget.side != null;
    hasBanner = widget.banner != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: [
            (!hasSide) ? sidelessLayout() : sidefulLayout(),
            widget.navBar,
          ],
        ));
  }

  Widget sidelessLayout() {
    return ListView(
      children: [
        hasBanner ? widget.banner : Container(),
        Container(
          child: widget.adaptivePage
              ? AdaptivePageFrame(
                  child: widget.body,
                )
              : widget.body,
        ),
      ],
    );
  }

  Widget sidefulLayout() {
    return ListView(children: [
      hasBanner ? widget.banner : Container(),
      Padding(
          padding: EdgeInsets.all(10),
          child: context.adaptiveMode.isSmallerThanL
              ? Row(
                  children: [widget.body, widget.side],
                )
              : Column(children: [
                  widget.body,
                  widget.side,
                ])),
    ]);
  }
}
