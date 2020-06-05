import 'dart:ui';

import 'package:cabin/base/error.dart';
import 'package:cabin/base/tasker.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:cabin/base/user.dart';

class CabinNavBar extends StatefulWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(50.0);
  bool autoLeading;
  CabinNavBar({this.autoLeading = true});
  createState() => CabinNavBarState();
}

class CabinNavBarState extends State<CabinNavBar> {
  double _screenWidth;
  double _screenHeight;
  _Tasker tasker;

  bool useCloseButton;

  @override
  void initState() {
    tasker = _Tasker(() {
      if (!mounted) return;
      setState(() {
        debugPrint("setState!");
      });
    });
    super.initState();
    tasker.start();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
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
                          if (widget.autoLeading != false && leading() != null)
                            leading()
                          else
                            Container(width: 50, height: 50),
                          Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .popUntil(ModalRoute.withName('/home'));
                                  },
                                  child: Image.asset("images/title.png"))),
                          accountSpace(),
                        ])))));
  }

  Widget leading() {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    if (Navigator.of(context).canPop())
      return useCloseButton ? const CloseButton() : const BackButton();
    else
      return null;
  }

  Widget accountSpace() {
    if (tasker.loginStatus == false)
      return RaisedButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/login');
            if (!mounted) return;
            setState(() {});
          },
          child: Text("登录"));
    else
      return FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, "/PersonalHome");
          },
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text("个人中心", style: TextStyle(color: Colors.black))),
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black38, spreadRadius: 1, blurRadius: 5)
                    ], borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: tasker.avatar))
              ]));
  }
}

class _Tasker extends Tasker {
  Map<String, dynamic> _data = Map<String, dynamic>();

  /// for `login` and `tryLogin`:
  /// if detect local info about account, set `tryLogin` = `true`;
  /// => if login fail, roll back to `false`;
  /// => if login success, set both to `true`;

  _Tasker(onFinished) : super(onFinished: onFinished);

  UserProvider provider = UserProvider.instance;

  @override
  Future<void> task() async {
    await accountTask();
  }

  Future accountTask() async {
    bool error = false;
    try {
      bool result = await provider.tryGetMyInfo();
    } on CabinError catch (e) {
      error = true;
      BotToast.showNotification(
        leading: (_) => Icon(Icons.cancel, color: Colors.red),
        title: (_) => Text("通信错误，请重新打开网站。"),
        subtitle: (_) => Text(e.toString()),
      );
    }
    if (error) cancelOrder = true;
  }

  Widget get avatar {
    if ((UserProvider.currentUser) != null) {
      if (UserProvider.currentUser.avatar == "none") {
        debugPrint("none");
        return Image.asset(
          "images/avatar_default.jpg",
          fit: BoxFit.cover,
        );
      }
      return Image.network(
        ((UserProvider.currentUser)).avatar,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, chunk) => chunk == null
            ? child
            : Container(
                width: 50, height: 50, child: CircularProgressIndicator()),
      );
    } else
      return CircularProgressIndicator();
  }

  String get name {
    if (loginStatus == true)
      return (UserProvider.currentUser).name;
    else
      return "正在加载";
  }

  bool get loginStatus {
    return UserProvider.loginStatus;
  }
}
