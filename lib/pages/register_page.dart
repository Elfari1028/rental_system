import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/adaptive.dart';
import 'package:cabin/widget/cabin_card.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController telCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController pwCtrl = TextEditingController();
  TextEditingController pw2Ctrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  UserSex sexCtrl = UserSex.male;
  bool isRegistering = false;
  Map errorMap = Map<String, dynamic>();

  @override
  void initState() {
    super.initState();
    errorMap["telE"] = false;
    errorMap["emailE"] = false;
    errorMap["passE"] = false;
    errorMap["passRepE"] = false;
    errorMap["ageE"] = false;
    errorMap["nameE"] = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: CabinCard(
          onPressed: () {},
          child: Container(
            width: context.adaptiveMode.isSmallerThanS ? null : 400,
            height: context.adaptiveMode.isSmallerThanS ? null : 650,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: isRegistering == true
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
                        "注册",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "输入昵称（可修改）",
                          errorText:
                              errorMap["nameE"] ? errorMap["name"] : null,
                          errorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                        onChanged: (value) {
                          if (value.length == 0) {
                            errorMap["nameE"] = true;
                            errorMap["name"] = "不得留空";
                          } else if (value.length > 18) {
                            errorMap["nameE"] = true;
                            errorMap["name"] = "不得超过18字符";
                          } else
                            errorMap["nameE"] = false;
                          setState(() {});
                        },
                        controller: nameCtrl,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "输入手机号",
                          errorText: errorMap["telE"] ? errorMap["tel"] : null,
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        onChanged: (value) {
                          if (value.contains("^[0-9]")) {
                            errorMap["tel"] = "不得包含字符！";
                            errorMap["telE"] = true;
                          } else if (value.length == 0) {
                            errorMap["tel"] = "不得留空！";
                            errorMap["telE"] = true;
                          } else if (value.length != 11) {
                            errorMap["tel"] = "需要是11位数字！";
                            errorMap["telE"] = true;
                          } else
                            errorMap["telE"] = false;
                          setState(() {});
                        },
                        controller: telCtrl,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "输入邮箱地址",
                          errorText:
                              errorMap["emailE"] ? errorMap["email"] : null,
                          errorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                        onChanged: (value) {
                          if (value.length == 0) {
                            errorMap["emailE"] = true;
                            errorMap["email"] = "不得留空";
                          } else if (!RegExp(regexEmail).hasMatch(value)) {
                            errorMap["emailE"] = true;
                            errorMap["email"] = "格式错误";
                          } else
                            errorMap["emailE"] = false;
                          setState(() {});
                        },
                        controller: emailCtrl,
                      ),
                      TextField(
                        controller: pwCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "输入密码",
                          errorText:
                              errorMap["passE"] ? errorMap["pass"] : null,
                          errorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                        onChanged: (value) {
                          if (value.length < 6 || value.length > 16) {
                            errorMap["passE"] = true;
                            errorMap["pass"] = "密码长度在6-16之间";
                          } else if (!RegExp(regexPw).hasMatch(value)) {
                            errorMap["passE"] = true;
                            errorMap["pass"] = "至少包含一个数字/大小写字母";
                          } else
                            errorMap["passE"] = false;
                          setState(() {});
                        },
                      ),
                      TextField(
                        controller: pw2Ctrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "输入确认密码",
                          errorText:
                              errorMap["passRepE"] ? errorMap["passRep"] : null,
                          errorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                        onChanged: (value) {
                          if (value.length < 6 || value.length > 16) {
                            errorMap["passRepE"] = true;
                            errorMap["passRep"] = "长度在8-16之间";
                          } else if (value != pwCtrl.text) {
                            errorMap["passRepE"] = true;
                            errorMap["passRep"] = "密码与上次输入不同";
                          } else
                            errorMap["passRepE"] = false;
                          setState(() {});
                        },
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "输入年龄",
                          errorText: errorMap["ageE"] ? errorMap["age"] : null,
                          errorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                        ),
                        onChanged: (value) {
                          if (value.contains(RegExp(r'[^0-9]'))) {
                            errorMap["age"] = "不得包含字符！";
                            errorMap["ageE"] = true;
                          } else if (value.length < 1 || value.length > 3) {
                            errorMap["age"] = "大小错误！";
                            errorMap["ageE"] = true;
                          } else
                            errorMap["ageE"] = false;
                          setState(() {});
                        },
                        controller: ageCtrl,
                      ),
                      Row(
                        children: [
                          Radio<UserSex>(
                            value: UserSex.male,
                            groupValue: sexCtrl,
                            onChanged: onSexChanged,
                          ),
                          Text("男"),
                          SizedBox(width: 50),
                          Radio<UserSex>(
                              value: UserSex.female,
                              groupValue: sexCtrl,
                              onChanged: onSexChanged),
                          Text("女"),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                isRegistering = true;
                                setState(() {});
                                tryRegister(context);
                              },
                              color: Colors.blue,
                              child: Text(
                                "注册",
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

  void onSexChanged(UserSex sex) {
    setState(() {
      sexCtrl = sex;
    });
  }

  Future tryRegister(BuildContext context) async {
    // print("am i ever here");
    UserProvider provider = UserProvider.instance;
    if(errorMap.containsValue(true)){
      Toaster.showToast(leading:Icon(Icons.warning,color: Colors.red,), title: "请先检查错误！");
      isRegistering = false;
      setState(() {});
      return ;
    }
    bool result = true;
    try {
      User user = User(
          name: nameCtrl.text,
          password: pwCtrl.text,
          phone: telCtrl.text,
          email: emailCtrl.text,
          sex: UserSexHelper.fromInt(sexCtrl.value),type: UserType.rentee,intro:"简介为空",age: int.parse(ageCtrl.text),avatar: "none");
      await provider.register(user);
    } on CabinError catch (e) {
      result = false;
      BotToast.showNotification(
        leading: (func) => Icon(
          Icons.error,
          color: Colors.red,
        ),
        title: (func) => Text(
          "注册失败",
          style: TextStyle(fontSize: 25),
        ),
        subtitle: (func) => Text(
          e.toString(),
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      );
    }
    if (result) {
      BotToast.showNotification(
        leading: (func) => Icon(
          Icons.done,
          color: Colors.green,
        ),
        title: (func) => Text(
          "注册成功",
          style: TextStyle(fontSize: 25),
        ),
        subtitle: (func) => Text(
          "请继续进行您的操作",
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      );
      Navigator.of(context).pop();
    } else {
      isRegistering = false;
      setState(() {});
    }
  }
}
