import 'package:cabin/base/house.dart';
import 'package:cabin/widget/adaptive.dart';
import 'package:cabin/widget/cabin_card.dart';
import 'package:flutter/material.dart';

class CabinHouseCard extends StatelessWidget {
  final House house;

  CabinHouseCard({@required this.house});

  static double adaptiveRatio(double maxExtent, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    EdgeInsets padding = context.adaptivePagePadding;
    double padWidth = padding.left * 2;
    double availWidth = width - padWidth;
    int itemCount = (availWidth / maxExtent).ceil();
    double itemWidth = availWidth / itemCount;
    double k = (285 - maxExtent * 0.968) / (237 - maxExtent);
    double itemHeight = (k) * itemWidth + maxExtent * 0.968 - maxExtent * k;
    // debugPrint("i:$itemCount aw:$availWidth h:$itemHeight w:$itemWidth");

    return itemWidth / itemHeight;
  }

  @override
  Widget build(BuildContext context) {
    return CabinCard(
      onPressed: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3.0,
            child: house == null
                ? Container(color: Colors.grey)
                : Container(child: house.cover),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  infoText(),
                  title(),
                ]),
          )
        ],
      ),
    );
  }

  Text infoText() {
    if (house == null)
      return Text(
        "---" + "·￥" + "---" + "·" + "---",
        style: TextStyle(color: Colors.brown, fontSize: 15),
      );
    else
      return Text(
        house.capType +
            "·￥" +
            house.priceInYuan.toString() +
            "每晚·" +
            house.rentType,
        style: TextStyle(color: Colors.brown, fontSize: 15),
      );
  }

  Text title() {
    if (house == null)
      return Text(
        "加载中",
        style: TextStyle(color: Colors.black, fontSize: 19),
      );
    else
      return Text(
        house.title,
        softWrap: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      );
  }
}

class CabinHouseGridView extends StatelessWidget {
  final bool shrinkWrap;
  final double maxExtent;
  ScrollPhysics physics;
  final List<House> children;
  CabinHouseGridView({
    this.shrinkWrap = false,
    this.maxExtent = 475.0,
    this.physics,
    @required this.children,
  }) {
    assert(this.children != null);
    this.physics ??= NeverScrollableScrollPhysics();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> builds = new List<Widget>();
    children.forEach((element) {
      builds.add(CabinHouseCard(house: element));
    });
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 475,
        childAspectRatio: CabinHouseCard.adaptiveRatio(475, (context)),
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: builds,
    );
  }
}
