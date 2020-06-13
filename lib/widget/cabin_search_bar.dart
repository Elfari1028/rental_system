import 'dart:isolate';

import 'package:cabin/base/house.dart';
import 'package:flutter/material.dart';
import 'adaptive.dart';
import 'cabin_card.dart';

class CabinSearchBar extends StatefulWidget {
  final Function(String keyword) onSearch;
  final Function(HouseTerm roomType) onTermChange;
  final Function(HouseCapacity roomCap) onCapChange;
  CabinSearchBar({@required this.onSearch, @required this.onTermChange,@required this.onCapChange});
  createState() => CabinSearchBarState();
}

class CabinSearchBarState extends State<CabinSearchBar> {
  double _screenWidth;
  double _screenHeight;
  TextEditingController keyword = TextEditingController();
  HouseTerm term;
  HouseCapacity capacity;
  List<String> optionsName = ["人数", "类型"];
  @override
  Widget build(BuildContext context) {
    return context.adaptiveMode.isLargerThanM
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [searchBar(), optionsBar()],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [searchBar(), optionsBar()],
          );
  }

  Widget searchBar() {
    return Container(
      width: 500,
      height: 75,
      child: Card(
        color: Colors.white,
        child: TextField(
          controller: keyword,
          decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintText: "在这里输入关键词",
              suffix: RaisedButton(
                  color: Colors.brown,
                  onPressed: () {
                    widget.onSearch(keyword.text);
                  },
                  child: Text("搜索", style: TextStyle(color: Colors.white)))),
        ),
      ),
    );
  }

  Widget optionsBar() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: PopupMenuButton<HouseCapacity>(
              itemBuilder: (builder) => <PopupMenuEntry<HouseCapacity>>[
                PopupMenuItem<HouseCapacity>(
                    value: HouseCapacity.mono,
                    child: Text("单人间", style: TextStyle(fontSize: 20))),
                PopupMenuItem<HouseCapacity>(
                    value:HouseCapacity.bi,
                    child: Text("双人间", style: TextStyle(fontSize: 20))),
                PopupMenuItem<HouseCapacity>(
                    value: HouseCapacity.quad,
                    child: Text("四人间", style: TextStyle(fontSize: 20))),
              ],
              child: IgnorePointer(child:RaisedButton(onPressed: (){},child:Text(optionsName[0]))),
              onSelected: (value) {
                widget.onCapChange(
                  value
                );
                optionsName[0] = value.title;
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: PopupMenuButton<HouseTerm>(
              itemBuilder: (builder) => <PopupMenuEntry<HouseTerm>>[
                PopupMenuItem<HouseTerm>(
                    value: HouseTerm.short,
                    child: Text(
                      "短租",
                      style: TextStyle(fontSize: 20),
                    )),
                PopupMenuItem<HouseTerm>(
                    value: HouseTerm.long,
                    child: Text(
                      "长租",
                      style: TextStyle(fontSize: 20),
                    )),
              ],
              child:IgnorePointer(child:RaisedButton(onPressed: (){},child:Text(optionsName[1]))),
              onSelected: (value) {
                widget.onTermChange(value);
                optionsName[1] =value.title;
                setState(() {});
              },
            ),
          )
        ]);
  }

  Widget button(String name) {
    return Container(
      width: 100,
      child: CabinCard(
        onPressed: () {},
        borderRadius: BorderRadius.circular(2.5),
        child: Text(name),
      ),
    );
  }

}
