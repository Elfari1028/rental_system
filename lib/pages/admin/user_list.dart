import 'package:cabin/base/user.dart';
import 'package:cabin/widget/cabin_data_table.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:flutter/material.dart';

class AdminUserListPage extends StatefulWidget {
  createState() => AdminUserListPageState();
}

class AdminUserListPageState extends State<AdminUserListPage> {
  bool dataReady = false;
  List<User> allusers;

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
              child: CabinDataTable(items: allusers,userType: UserType.service,))
          : Center(
              child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            )),
    );
  }

  Future getList() async {
    allusers = await UserProvider.instance.getAllUsers();
    if (allusers != null) dataReady = true;
    setState(() {});
  }
}
