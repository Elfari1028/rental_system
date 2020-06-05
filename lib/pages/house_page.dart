import 'dart:core';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/widget/cabin_card.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class HousePage extends StatefulWidget {
  createState() => HousePageState();
}

class HousePageState extends State<HousePage> {
  House house;
  bool firstBuild = true;
  DateTime startDate;
  DateTime endDate;
  int endCount = 1;
  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = startDate.add(Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    house = ModalRoute.of(context).settings.arguments as House;
    if (house == null) {
      BotToast.showNotification(
          leading: (_) => Icon(Icons.error_outline, color: Colors.red),
          title: (_) => Text("当前页不支持刷新!",
              style: TextStyle(color: Colors.red, fontSize: 25)),
          duration: Duration(seconds: 5));
      // Navigator.of(context).pop();
    }
    return house == null
        ? Center(child: CircularProgressIndicator())
        : CabinScaffold(
            navBar: CabinNavBar(),
            banner: carousel(),
            body: body(),
            side: side(),
          );
  }

  Widget carousel() => Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1)
            ],
            image: DecorationImage(
                image: NetworkImage(house.imagePaths.first), fit: BoxFit.cover),
          ),
          padding: EdgeInsets.only(bottom: 30),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: CarouselSlider(
                  items: imageCards(),
                  options: CarouselOptions(
                    // height: 600,
                    aspectRatio: 16 / 5,
                    autoPlay: true,
                    initialPage: 0,
                    viewportFraction: 0.6,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )))));
  Widget body() => Container(
      width: 600,
      child: MarkdownWidget(
        data: house.intro,
        shrinkWrap: true,
      ));
  List<Widget> imageCards() {
    List<Widget> ret = List<Widget>();
    ret.add(CabinCard(
      // height: 600,
      // width: 50,
      borderRadius: BorderRadius.circular(15),
      child: house.images[0],
      onPressed: () {},
      elevation: 7.0,
      hoverElevation: 10.0,
      padding: EdgeInsets.zero,
    ));
    for (int i = 1; i < house.images.length; i++) {
      ret.add(CabinCard(
        // height: 600,
        // width: 50,
        borderRadius: BorderRadius.circular(15),
        child: house.images[i],
        onPressed: () {},
        elevation: 7.0,
        hoverElevation: 10.0,
        padding: EdgeInsets.zero,
      ));
    }
    return ret;
  }

  Widget side() => Container(
        width: 400,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(house.priceInYuan.toString() + "￥",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text(house.term.adv)
                ]),
            Divider(),
            Padding(padding: EdgeInsets.all(10), child: Text("入住时间")),
            house.term.isShort
                ? shortTermRangeSelector()
                : longTermRangeSelector(),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      "提交申请",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    color: Colors.blue,
                    hoverColor: Colors.blueAccent,
                    highlightColor: Colors.blue[800],
                    padding: EdgeInsets.all(10),
                  )),
            )
          ],
        ),
      );

  Widget shortTermRangeSelector() => Container(
      height: 50,
      width: 400,
      decoration: BoxDecoration(
        border: Border.all(width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            onPressed: () async {
              DateTime date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030));
              if (date != null) startDate = date;
              setState(() {});
            },
            child: Text(startDate.month.toString() +
                "月" +
                startDate.day.toString() +
                "日"),
          ),
          Icon(Icons.arrow_forward),
          FlatButton(
            onPressed: () async {
              DateTime date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030));
              if (date != null) endDate = date;
              setState(() {});
            },
            child: Text(
                endDate.month.toString() + "月" + endDate.day.toString() + "日"),
          ),
        ],
      ));

  Widget longTermRangeSelector() => Container(
      height: 50,
      width: 400,
      decoration: BoxDecoration(
        border: Border.all(width: 1),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        FlatButton(
          onPressed: () async {
            DateTime date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030));
            if (date != null) startDate = date;
            setState(() {});
          },
          child: Text(startDate.month.toString() +
              "月" +
              startDate.day.toString() +
              "日"),
        ),
        Icon(Icons.date_range),
        PopupMenuButton(
          itemBuilder: (context) => <PopupMenuEntry<int>>[
            PopupMenuItem(value: 1, child: Text("1")),
            PopupMenuItem(value: 2, child: Text("2")),
            PopupMenuItem(value: 3, child: Text("3")),
            PopupMenuItem(value: 4, child: Text("4")),
            PopupMenuItem(value: 5, child: Text("5")),
            PopupMenuItem(value: 6, child: Text("6")),
            PopupMenuItem(value: 7, child: Text("7")),
            PopupMenuItem(value: 8, child: Text("8")),
            PopupMenuItem(value: 9, child: Text("9")),
            PopupMenuItem(value: 10, child: Text("10")),
            PopupMenuItem(value: 11, child: Text("11")),
            PopupMenuItem(value: 12, child: Text("12")),
          ],
          onSelected: (value) {
            endCount = value;
            setState(() {});
          },
          child: Text("入住" + endCount.toString() + "个月"),
        )
      ]));
}
