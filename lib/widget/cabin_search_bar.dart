import 'package:flutter/material.dart';
import 'adaptive.dart';
import 'cabin_card.dart';

class CabinSearchBar extends StatefulWidget {
  final Function(String keywords, int roomType) onSearch;
  final Function(String keyword, int roomType) onOptionsChange;
  CabinSearchBar({@required this.onSearch, @required this.onOptionsChange});
  createState() => CabinSearchBarState();
}

class CabinSearchBarState extends State<CabinSearchBar> {
  double _screenWidth;
  double _screenHeight;
  TextEditingController keyword = TextEditingController();
  int type = 3;
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
                    widget.onSearch(keyword.text, type);
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
            child: PopupMenuButton<int>(
              itemBuilder: (builder) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                    value: 1,
                    child: Text("单人间", style: TextStyle(fontSize: 20))),
                PopupMenuItem<int>(
                    value: 2,
                    child: Text("双人间", style: TextStyle(fontSize: 20))),
                PopupMenuItem<int>(
                    value: 4,
                    child: Text("四人间", style: TextStyle(fontSize: 20))),
              ],
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  optionsName[0],
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onSelected: (value) {
                type = type.sign * value;
                optionsName[0] = capType;
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: PopupMenuButton<int>(
              itemBuilder: (builder) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                    value: -1,
                    child: Text(
                      "短租",
                      style: TextStyle(fontSize: 20),
                    )),
                PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      "长租",
                      style: TextStyle(fontSize: 20),
                    )),
              ],
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  optionsName[1],
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onSelected: (value) {
                type = type.abs() * value.sign;
                optionsName[1] = rentType;
                debugPrint("yes father");
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

  String get capType {
    switch (type) {
      case -1:
      case 1:
        return "单人间";
      case 2:
      case -2:
        return "双人间";
      case 4:
      case -4:
        return "四人间";
    }
    return null;
  }

  String get rentType {
    return type > 0 ? "短租" : "长租";
  }
}
