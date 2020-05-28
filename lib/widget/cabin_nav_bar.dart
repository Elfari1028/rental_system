import 'dart:ui';

import 'package:cabin/base/error.dart';
import 'package:cabin/base/provider.dart';
import 'package:cabin/base/tasker.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class CabinNavBar extends StatefulWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(50.0);
  createState() => CabinNavBarState();
}

class CabinNavBarState extends State<CabinNavBar> {
  double _screenWidth;
  double _screenHeight;
  _Tasker tasker;

  @override
  void initState() {
    tasker = _Tasker(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    tasker.start();
    return Container(
      width: _screenWidth,
      height: 50,
      color: Colors.transparent,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Container(
                    child: Image.asset(
                      "images/title.png",
                    ),
                  ),
                  accountSpace(),
                ],
              )),
        ),
      ),
    );
  }

  Widget accountSpace() {
    if (tasker.loginStatus == false)
      return RaisedButton(
          onPressed: () async {
            await Navigator.of(context).pushReplacementNamed('/login');
            setState(() {            
            });
          },
          child: Text("登录"));
    else
      return Container(
        child: Row(
          children: [
            Text("个人中心", style: TextStyle(color: Colors.black)),
            Container(
              child: IconButton(icon: Icon(Icons.person), onPressed: () {}),
            )
          ],
        ),
      );
  }
}

class _Tasker extends Tasker {
  Map<String, dynamic> _data = Map<String, dynamic>();

  /// for `login` and `tryLogin`:
  /// if detect local info about account, set `tryLogin` = `true`;
  /// => if login fail, roll back to `false`;
  /// => if login success, set both to `true`;

  Map<String, bool> _status = <String, bool>{
    "avatar": false,
    "name": false,
    "weather": false,
    "tryLogin": false,
    "login": false,
  };

  _Tasker(onFinished) : super(onFinished: onFinished);

  @override
  Future<void> task() async {
    await accountTask().whenComplete(() => onFinished);
  }

  Future accountTask() async {
    bool accountExist = await LocalData.containsKey("currentID");
    if (!accountExist) return;
    _status["tryLogin"] = true;
    LoginInfoProvider provider = LoginInfoProvider();
    try {
      provider.login(await LocalData.obtainValue("currentID"),
          await LocalData.obtainValue("currentPW"));
    } on CabinError catch (e) {
      _status["tryLogin"] = false;
      if (e.className == "LocalData" && e.code == "OV_KEY_NULL") {
        // do nothing
      } else {
        BotToast.showNotification(
          leading: (func) => Icon(
            Icons.error,
            color: Colors.red,
          ),
          title: (func) => Text(
            "登陆失败",
            style: TextStyle(fontSize: 25),
          ),
          subtitle: (func) => Text(
            e.toString(),
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        );
      }
    }
    if (_status["tryLogin"] == false) return;
    _status["login"] = true;
    _data["name"] = await LocalData.obtainValue("currentName");
    _data["avatar"] = await LocalData.obtainValue("currentAvatar");
  }

  Widget get avatar {
    if (_status["tryLogin"] == true || _status["avatar"] == true) {
      if (_status["login"] == true && _status["avatar"] == true) {
        if (_data["avatar"] == "none")
          return Image.asset("images/avatar_default.jpg");
        else
          return _data["avatar"];
      } else
        return CircularProgressIndicator();
    } else
      return CircularProgressIndicator();
  }

  String get name {
    if (_status[name] == true)
      return _data[name];
    else
      return "正在加载";
  }

  bool get loginStatus {
    return _status["tryLogin"];
  }
}
