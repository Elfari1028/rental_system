import 'package:cabin/base/house.dart';
import 'package:cabin/base/tasker.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:cabin/widget/cabin_search_bar.dart';
import 'package:cabin/widget/house_card.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  final String keyword;
  ExplorePage({this.keyword = ""});
  createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  double _screenWidth;
  double _screenHeight;
  _Tasker tasker;

  @override
  void initState() {
    super.initState();
    tasker = new _Tasker(() {
      if (!mounted) return;
      setState(() {});
    });
    tasker.start();
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
              onSearch: (keywords, type) {
                setState(() {});
              },
              onOptionsChange: (keywords, type) {
                setState(() {});
              },
            ),
            tasker.houseListReady
                ? CabinHouseGridView(
                    children: tasker.houselist,
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

class _Tasker extends Tasker {
  Map _status = <String, bool>{"houselist": false};
  Map _data = Map<String, dynamic>();

  _Tasker(onFinished) : super(onFinished: onFinished);
  Future task() async {
    await Future.delayed(Duration(seconds: 2));
    _data["houselist"] = await HouseProvider.getDemoRecom();
    _status["houselist"] = true;
  }

  bool get houseListReady => _status["houselist"];
  List<House> get houselist => houseListReady ? _data["houselist"] : null;
}
