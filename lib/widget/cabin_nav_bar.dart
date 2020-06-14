import 'dart:ui';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/tasker.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
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
      setState(() {});
    });
    super.initState();
    tasker.start();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Hero(tag:"appbar",child: AppBar(
      backgroundColor: Color.lerp(Colors.orange[800],Colors.brown,0.8),
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.autoLeading != false && leading() != null)
                              leading()
                            else
                              Container(
                                width: 50,
                              ),
                            Align(
                                alignment: Alignment.center,
                                child: Container(height:50,child:FlatButton(
                                    onPressed: () {
                                    },
                                    padding: EdgeInsets.all(5),
                                    child: Image.asset("images/title.png",fit: BoxFit.cover,)))),
                            accountSpace(),
                          ]))
    ));
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
      return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 1, blurRadius: 5)
          ], borderRadius: BorderRadius.circular(20)),
          child: FlatButton(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: ()async {
                String name =ModalRoute.of(context).settings.name;
                if((name !="/center"&&name !="/home") || (name == '/home' && (UserProvider.currentUser.type == UserType.rentee))){
                   await Navigator.pushNamed(context, "/center");
                }
                else await Navigator.pushReplacementNamed(context, "/center");
                tasker.start();
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: tasker.avatar)));
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
