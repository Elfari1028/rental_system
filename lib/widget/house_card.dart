import 'package:cabin/base/house.dart';
import 'package:cabin/widget/adaptive.dart';
import 'package:cabin/widget/cabin_card.dart';
import 'package:flutter/material.dart';

class CabinHouseCard extends StatelessWidget {
  final House house;

  CabinHouseCard({@required this.house});

  @override
  Widget build(BuildContext context) {
    return CabinCard(
      onPressed: () {
        Navigator.of(context).pushNamed("/HouseDetail", arguments: this.house);
      },
      borderRadius: BorderRadius.circular(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3.0,
            child: house == null
                ? Container(color: Colors.grey)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: house.cover),
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
        house.capacity.title +
            "·￥" +
            house.priceInYuan.toString() +
            house.term.adv +
            house.term.title,
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
        maxCrossAxisExtent: 520,
        childAspectRatio: context.adaptiveRatio(
            maxWidth: 520, maxHeight: 500, minHeight: 300),
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: builds,
    );
  }
}
