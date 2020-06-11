import 'package:cabin/base/house.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/cabin_data_table.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:flutter/material.dart';

class AdminHouseListPage extends StatefulWidget {
  createState() => AdminHouseListPageState();
}

class AdminHouseListPageState extends State<AdminHouseListPage> {
  bool dataReady = false;
  List<House> allhouses;

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
              child: CabinDataTable(items: allhouses,userType: UserType.service,))
          : Center(
              child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            )),
    );
  }

  Future getList() async {
    allhouses = await HouseProvider.instance.getAllHouses();
    if (allhouses != null) dataReady = true;
    setState(() {});
  }
}
