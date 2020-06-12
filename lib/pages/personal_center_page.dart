import 'package:cabin/base/user.dart';
import 'package:cabin/widget/cabin_card.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:cabin/widget/adaptive.dart';

class PersonalCenterPage extends StatefulWidget {
  createState() => PersonalCenterPageState();
}

class PersonalCenterPageState extends State<PersonalCenterPage> {
  double _screenWidth;
  double _screenHeight;
  UserProvider userProvider = UserProvider.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    if (UserProvider.loginStatus == false) Navigator.of(context).pop();
    return CabinScaffold(
      navBar: CabinNavBar(),
      body: infoCard(),
      side: introCard(),
      extendedBody: actionGrid(),
    );
  }

  Widget infoCard() {
    return Container(
        width: 500,
        height: 400,
        padding: EdgeInsets.all(10),
        child: Card(
            elevation: 10.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 150,
                      height: 150,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: UserProvider.currentUser.avatar != "none"
                              ? Image.network(
                                  UserProvider.currentUser.avatar,
                                  fit: BoxFit.cover,
                                )
                              : User.defaultAvatar),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          border: Border.all(color: Colors.black, width: 1))),
                  FlatButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamed('/account/edit',arguments:{'user':UserProvider.currentUser,'isAdmin':false} );
                        // setState(() {});
                      },
                      child: Text("编辑资料")),
                  Divider(),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone),
                        Text("电话:" + UserProvider.currentUser.phone)
                      ]),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email),
                        Text("邮箱:" + UserProvider.currentUser.email)
                      ]),
                ])));
  }

  Widget introCard() {
    return Container(
        width: 500,
        height: 400,
        padding: EdgeInsets.all(10),
        child: Card(
            elevation: 10.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(UserProvider.currentUser.name,
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Divider(),
                Text(UserProvider.currentUser.intro,
                    style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic))
              ],
            )));
  }

  Widget actionGrid() {
    return GridView(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 600,
        childAspectRatio: context.adaptiveRatio(
          maxWidth: 600,
          maxHeight: 400,
          minHeight: 350,
        ),
      ),
      children: actions(),
    );
  }

  List<Widget> actions() {
    List<Widget> ret = List<Widget>();
    switch (UserProvider.currentUser.type) {
      case UserType.service:
        ret.add(actionCard("订单管理", Icons.payment, () {
          Navigator.of(context).pushNamed('/order/all');}));
        ret.add(actionCard("工单管理", Icons.feedback, () {
          Navigator.of(context).pushNamed('/support/all');}));
        ret.add(actionCard("房源管理", Icons.home, () {
          Navigator.of(context).pushNamed('/house/all');
        }));
        ret.add(actionCard("用户管理", Icons.contacts, () {
          Navigator.of(context).pushNamed('/account/all');
        }));
        break;
      case UserType.maintenance:
        ret.add(actionCard("工单管理", Icons.feedback, () {}));
        break;
      case UserType.rentee:
        ret.add(actionCard("订单管理", Icons.payment,() {
          Navigator.of(context).pushNamed('/order/mine');}));
        ret.add(actionCard("投诉报修", Icons.feedback, () {}));
    }
    return ret;
  }

  Widget actionCard(String name, IconData icon, Function onPressed) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    colors: [Colors.blue[600], Colors.blue[300]],
                    stops: [0.0, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: RaisedButton(
                onPressed: onPressed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 5.0,
                highlightElevation: 1.0,
                hoverElevation: 10.0,
                color: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.black12,
                splashColor: Colors.transparent,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(icon, size: 50, color: Colors.white),
                      Text(name,
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                    ]))));
  }
}
