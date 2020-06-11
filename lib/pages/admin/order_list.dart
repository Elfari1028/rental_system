import 'package:cabin/base/order.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/cabin_data_table.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:flutter/material.dart';

class AdminOrderListPage extends StatefulWidget {
  createState() => AdminOrderListPageState();
}

class AdminOrderListPageState extends State<AdminOrderListPage> {
  bool dataReady = false;
  List<Order> allorders;

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return CabinScaffold(
      navBar: CabinNavBar(),
      adaptivePage: false,
      body: dataReady
          ? Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 60),
              child: CabinDataTable(items: allorders,userType: UserType.service,))
          : Center(
              child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            )),
    );
  }

  Future getList() async {
    allorders = await OrderProvider.instance.getAllOrders();
    if (allorders != null) dataReady = true;
    setState(() {});
  }
}
