import 'package:cabin/widget/adaptive.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:flutter/material.dart';

class CabinScaffold extends StatelessWidget {
  final CabinNavBar navBar;
  final Widget banner;
  final Widget body;
  final Widget side;
  final Widget extendedBody;
  final bool adaptivePage;
  bool hasSide = false;
  bool hasBanner = false;
  bool isExtended = false;
  CabinScaffold({
    @required this.navBar,
    this.banner,
    this.side,
    @required this.body,
    this.adaptivePage = true,
    this.extendedBody,
  }) {
    hasSide = side != null;
    hasBanner = banner != null;
    isExtended = extendedBody != null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: [
            (!hasSide) ? sidelessLayout(context) : sidefulLayout(context),
            navBar,
          ],
        ));
  }

  Widget sidelessLayout(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        if (hasBanner) banner,
        Container(
          child: adaptivePage
              ? Padding(
                  padding: context.adaptivePagePadding,
                  child: body,
                )
              : body,
        ),
        if (isExtended) extendedBody,
      ],
    );
  }

  Widget sidefulLayout(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      hasBanner ? banner : Container(height: 50),
      Padding(
          padding: adaptivePage
              ? EdgeInsets.symmetric(horizontal: 10)
              : context.adaptivePagePadding,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                context.adaptiveMode.isLargerThanM
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Expanded(child: body, flex: 6),
                            Expanded(child: side, flex: 4),
                          ])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [body, side]),
                if (isExtended) extendedBody,
              ])),
    ]);
  }
}
