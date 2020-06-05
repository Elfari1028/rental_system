import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/adaptive.dart';
import 'package:cabin/widget/cabin_card.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  double _screenWidth;
  double _screenHeight;

  TextEditingController idCtrl = TextEditingController();
  TextEditingController pwCtrl = TextEditingController();
  bool isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: CabinCard(
          onPressed: () {},
          child: Container(
            width: context.adaptiveMode.isSmallerThanS ? null : 400,
            height: context.adaptiveMode.isSmallerThanS ? null : 350,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: isLoggingIn == true
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            width: 50,
                            height: 50,
                            child: FlatButton(
                                shape: CircleBorder(),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })),
                      ),
                      Text(
                        "登录",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "输入手机号"),
                        keyboardType: TextInputType.phone,
                        controller: idCtrl,
                      ),
                      TextField(
                        controller: pwCtrl,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "输入密码"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: Text("注册"),
                            ),
                            RaisedButton(
                              onPressed: () {
                                isLoggingIn = true;
                                setState(() {});
                                tryLogin(context);
                              },
                              color: Colors.blue,
                              child: Text(
                                "登录",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future tryLogin(BuildContext context) async {
    // print("am i ever here");
    UserProvider provider = UserProvider.instance;
    bool result = true;
    try {
      await provider.login(idCtrl.text, pwCtrl.text);
    } on CabinError catch (e) {
      result = false;
      debugPrint(e.toString());
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
    if (result)
      Navigator.of(context).pop();
    else {
      isLoggingIn = false;
      setState(() {});
    }
  }
}
