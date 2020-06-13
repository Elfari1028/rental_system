import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/cabin_card.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HousePage extends StatefulWidget {
  House house;
  HousePage(this.house);
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
    house = widget.house;
    startDate = DateTime.now();
    endDate = startDate.add(Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
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
            adaptivePage: true,
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
                    viewportFraction: 0.5,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )))));
  Widget body() => Card(
      elevation: 7.0,
      child: Container(
          width: 600,
          padding: EdgeInsets.all(30),
          child: MarkdownWidget(
            physics: NeverScrollableScrollPhysics(),
            data: house.intro,
            shrinkWrap: true,
          )));
  List<Widget> imageCards() {
    List<Widget> ret = List<Widget>();
    for (int i = 0; i < house.images.length; i++) {
      ret.add(FittedBox(
          fit: BoxFit.cover,
          child: Container(
              // height: 600,
              padding: EdgeInsets.all(50),
              child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: Colors.transparent,
                hoverColor: Colors.white10,
                highlightColor: Colors.black12,
                elevation: 7.0,
                hoverElevation: 10.0,
                padding: EdgeInsets.zero,
                child: house.images[i],
              ))));
    }
    return ret;
  }

  Widget side() => Card(
      elevation: 7.0,
      child: Container(
        width: 600,
        padding: EdgeInsets.all(15),
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
                    onPressed: () {
                      placeOrder();
                    },
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
      ));

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

  void placeOrder() async {
    if (UserProvider.currentUser == null) {
      Toaster.showToast(title: "请先登录");
      return;
    }
    OrderType orderType = OrderTypeHelper.fromInt(widget.house.term.value);
    DateTime end = orderType.isShort
        ? endDate
        : endDate.add(Duration(days: endCount * 30));
    int amount =
        orderType.isShort ? endDate.difference(startDate).inDays : endCount;
    amount = house.price * amount;
    Order order = Order.create(startDate, end, UserProvider.currentUser.id,
        widget.house.id, orderType, amount);

    bool result = await showDialog<bool>(
        context: context,
        builder: (ctx) =>Dialog(child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280.0,maxWidth:700),
          child:Card(
              elevation: 5,
              margin: EdgeInsets.zero,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              child:
                  SingleChildScrollView(child:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                FittedBox(fit:BoxFit.fitWidth, child:house.cover,),
                ListTile(title: Text("房屋名称"), subtitle: Text(house.title)),
                Divider(),
                ListTile(
                  title: Text("订单金额"),
                  subtitle: Text(order.priceInYuan.toString() + "元"),
                ),
                Divider(),
                ListTile(
                  title: Text("入住日期"),
                  subtitle: Text(startDate.toShortString()),
                ),
                Divider(),
                ListTile(
                  title: Text("到期日期"),
                  subtitle: Text(end.toShortString()),
                ),
                Divider(),
                ListTile(
                  title: Text("您的联系电话"),
                  subtitle: Text(UserProvider.currentUser.phone),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: Text(
                      "注意: 下单后需等待通过审核再进行付款，请留心审核状态，一般在1-3工作日内完成。",
                      softWrap: true,
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    RaisedButton(
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("取消"),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text("确认"),
                    )
                  ] )
                )
              ])))))
        );
    if (result == null||result == false) return;
    final ProgressDialog pr =
        ProgressDialog(context, isDismissible: false, showLogs: true);
    await pr.show();
    print("SHOW");

    result = await OrderProvider.instance.create(order);
    if (result) {
      Toaster.showToast(title: "创建成功");
      if (orderType.isShort) {
        //TODO: ADD PAYMENT
      } else {
        //TODO: ADD PRINT
      }
    } else
      Toaster.showToast(title: "创建失败");
    pr.hide();
  }
}
