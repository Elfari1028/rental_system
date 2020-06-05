import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/support_request.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/cabin_data_table.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  String title;
  Type modelType;
  TablePage(this.title, this.modelType) : assert(modelType is CabinModel);
  createState() => TablePageState();
}

class TablePageState extends State<TablePage> {
  double _screenWidth;
  double _screenHeight;
  bool dataRetrieved = false;
  bool isSuperuser = false;
  List<CabinModel> items;
  @override
  void initState() {
    super.initState();
    if (UserProvider.currentUser.type == UserType.service) isSuperuser = true;
    startTask();
  }

  Future startTask() async {
    switch (widget.modelType) {
      case User:
        items = await UserProvider.instance.getAllUsers();
        break;
      // case House:
      //   items = await HouseProvider.instance.getAllHouses();
      //   break;
      // case Order:
      //   items = await (isSuperuser
      //       ? OrderProvider.instance.getAllOrders()
      //       : OrderProvider.instance.getMyOrders());
      //   break;
      // case SupportRequest:
      //   items = await (isSuperuser
      //       ? RequestProvider.instance.getAllRequests()
      //       : RequestProvider.getMyRequests());
      //   break;
      default:
        throw UnimplementedError();
    }
    dataRetrieved = true;
    setState(() {});
  }

  Future refresh() async {
    dataRetrieved = false;
    setState(() {});
    startTask();
  }

  @override
  Widget build(BuildContext context) {
    return CabinScaffold(
        navBar: CabinNavBar(), body: body(), adaptivePage: false);
  }

  Widget body() => Padding(
      padding: EdgeInsets.all(50),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(widget.title,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Card(child: CabinDataTable(items: items))
      ]));
}
