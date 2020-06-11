import 'package:flutter/material.dart';

enum AdaptiveMode { xs, s, m, l, xl }

extension AdaptiveHelper on AdaptiveMode {
  static AdaptiveMode from({@required double width}) {
    if (width < 576) {
      return AdaptiveMode.xs;
    } else if (width < 728) {
      return AdaptiveMode.s;
    } else if (width < 992) {
      return AdaptiveMode.m;
    } else if (width < 1200) {
      return AdaptiveMode.l;
    } else
      return AdaptiveMode.xl;
  }

  bool get isXs => AdaptiveMode.xs == this;
  bool get isS => AdaptiveMode.s == this;
  bool get isM => AdaptiveMode.m == this;
  bool get isL => AdaptiveMode.l == this;
  bool get isXl => AdaptiveMode.xl == this;

  bool isLargerThan(AdaptiveMode breakpoint) => breakpoint.index < this.index;
  bool get isLargerThanXs => this.isLargerThan(AdaptiveMode.xs);
  bool get isLargerThanS => this.isLargerThan(AdaptiveMode.s);
  bool get isLargerThanM => this.isLargerThan(AdaptiveMode.m);
  bool get isLargerThanL => this.isLargerThan(AdaptiveMode.l);
  bool get isLargerThanXl => this.isLargerThan(AdaptiveMode.xl);

  bool isSmallerThan(AdaptiveMode breakpoint) => breakpoint.index > this.index;
  bool get isSmallerThanXs => this.isSmallerThan(AdaptiveMode.xs);
  bool get isSmallerThanS => this.isSmallerThan(AdaptiveMode.s);
  bool get isSmallerThanM => this.isSmallerThan(AdaptiveMode.m);
  bool get isSmallerThanL => this.isSmallerThan(AdaptiveMode.l);
  bool get isSmallerThanXl => this.isSmallerThan(AdaptiveMode.xl);
}

extension Adaptive on BuildContext {
  EdgeInsets get adaptivePagePadding {
    double width = MediaQuery.of(this).size.width;
    print("width:"+width.toString());
    switch (this.adaptiveMode) {
      case AdaptiveMode.xs:
        return EdgeInsets.symmetric(horizontal: width * 0.025, vertical: 50);
      case AdaptiveMode.s:
        return EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 50);
      case AdaptiveMode.m:
        return EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 50);
      case AdaptiveMode.l:
        return EdgeInsets.symmetric(horizontal: width * 0.1, vertical: 50);
      case AdaptiveMode.xl:
        return EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 50);
    }
    return EdgeInsets.zero;
  }

  AdaptiveMode get adaptiveMode {
    double width = MediaQuery.of(this).size.width;
    return AdaptiveHelper.from(width: width);
  }

  double adaptiveRatio(
      {@required double maxHeight,
      @required double maxWidth,
      @required double minHeight}) {
    double width = MediaQuery.of(this).size.width;
    EdgeInsets padding = this.adaptivePagePadding;
    double padWidth = padding.left * 2;
    double availWidth = width - padWidth;
    int itemCount = (availWidth / maxWidth).ceil();
    double itemWidth = availWidth / itemCount;
    double minWidth = maxWidth / 2;
    double k = (minHeight - maxHeight) / (minWidth - maxWidth); //285 237 0.968
    double itemHeight = (k) * itemWidth + maxHeight - maxWidth * k;
    return itemWidth / itemHeight;
  }
}

class AdaptivePageFrame extends StatelessWidget {
  final Widget child;
  AdaptivePageFrame({@required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.adaptivePagePadding,
      child: child,
    );
  }
}
