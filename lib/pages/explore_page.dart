import 'package:cabin/base/house.dart';
import 'package:cabin/base/picture.dart';
import 'package:cabin/base/tasker.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:cabin/widget/cabin_search_bar.dart';
import 'package:cabin/widget/house_card.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  final String keyword;
  ExplorePage(this.keyword);
  createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  double _screenWidth;
  double _screenHeight;
  bool listReady = false;
  String keyword;
  HouseTerm term;
  HouseCapacity cap;
  List<House> houselist = new List<House>();
  @override
  void initState() {
    super.initState();
    keyword = widget.keyword;
    getList();
  }

  void getList() async {
    houselist = await HouseProvider.instance.getAvailables();
    if (houselist == null) {
      listReady = false;
      setState(() {});
      return;
    } else
      listReady = true;
    if (term != null) houselist.removeWhere((element) => element.term != term);
    if (cap != null)
      houselist.removeWhere((element) => element.capacity != cap);
    if (keyword != null) {
      houselist.retainWhere((element) =>
          element.title.contains(keyword) ||
          element.location.contains(keyword) ||
          element.intro.contains(keyword));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CabinScaffold(
      adaptivePage: false,
      navBar: CabinNavBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 60, 10, 0),
        child: Column(
          children: [
            CabinSearchBar(
              onSearch: (keywords) {
                keyword = keywords;
                getList();
                setState(() {});
              },
              onTermChange: (type) {
                term = type;
                getList();
                setState(() {});
              },
              onCapChange: (type) {
                cap = type;
                getList();
                setState(() {});
              },
            ),
            listReady
                ? CabinHouseGridView(
                    children: houselist,
                  )
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.brown),
                  )
          ],
        ),
      ),
    );
  }
}
