import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/editors.dart/input_field.dart';
import 'package:flutter/material.dart';
import 'package:cabin/widget/web_image_picker.dart';
import 'package:universal_html/html.dart';

class UserEditor extends StatefulWidget {
  User user;
  UserEditor(User user);
  createState() => UserEditorState();
}

class UserEditorState extends State<UserEditor> {
  double _screenWidth;
  double _screenHeight;

  Map<String, CabinInputFieldController> controllers;
  @override
  void initState() {
    super.initState();
    controllers = {
      "name": CabinInputFieldController(initValue:widget.user == null ? null : widget.user.name),
      "age":
          CabinInputFieldController(initValue:widget.user == null ? null : widget.user.age.toString()),
      "email": CabinInputFieldController(initValue:widget.user == null ? null : widget.user.email),
      "intro": CabinInputFieldController(initValue:widget.user == null ? null : widget.user.intro),
      "phone":CabinInputFieldController(initValue:widget.user == null ? null : widget.user.phone),
      "type":CabinInputFieldController(initValue:widget.user == null ? null : widget.user.type.value.toString()),
    };
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Center(
        child: Card(
      elevation: 50,
      child: Container(
        width: 500,
        padding: EdgeInsets.all(30),
        child: ListView(
          shrinkWrap: true,
          children: [
            Align(alignment: Alignment.centerLeft, child: BackButton()),
            avatarField(),
            nameField(),
            introField(),
            ageField(),
            emailField(),
            Align(alignment: Alignment.centerLeft, child: submitButton()),
          ],
        ),
      ),
    ));
  }

  Widget submitButton() => RaisedButton(
        onPressed: () {},
        child: Text("提交"),
      );
  Widget avatarField() => Column(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(37.5),
            child: Container(height: 75, width: 75, child: data["avatar"])),
        FlatButton(
            onPressed: () async {
              WebImagePicker picker = WebImagePicker();
              bool result = await picker.pickFile();
              if (result = true) {
                data["avatar"] = picker.image;
                data["avatarFile"] = picker.file;
                setState(() {});
              } else {
                BotToast.showSimpleNotification(title: "请重新尝试");
              }
            },
            child: Text("选择图片"))
      ]);

  Widget nameField() => TextField(
        decoration: InputDecoration(
          hintText: "输入昵称（可修改）",
          errorText: errorMap["nameE"] ? errorMap["name"] : null,
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1)),
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
          data["name"] = value;
        },
        controller: controllers['name'],
      );
  Widget introField() => TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: "输入个人简介",
          errorText: errorMap["introE"] ? errorMap["intro"] : null,
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1)),
        ),
        onChanged: (value) {
          if (value.length == 0) {
            errorMap["introE"] = true;
            errorMap["intro"] = "不得留空";
          } else if (value.length > 128) {
            errorMap["introE"] = true;
            errorMap["intro"] = "不得超过128字符";
          } else
            errorMap["nameE"] = false;
          data['intro'] = value;
          setState(() {});
        },
        controller: controllers['intro'],
      );
  Widget ageField() => TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "输入年龄",
          errorText: errorMap["ageE"] ? errorMap["age"] : null,
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1)),
        ),
        onChanged: (value) {
          if (value.contains(RegExp(r"[^0-9]"))) {
            errorMap["age"] = "不得包含字符！";
            errorMap["ageE"] = true;
          } else if (value.length < 1 || value.length > 3) {
            errorMap["age"] = "大小错误！";
            errorMap["ageE"] = true;
          } else
            errorMap["ageE"] = false;
          data["age"] = value;
          setState(() {});
        },
        controller: controllers['age'],
      );

  final String regexEmail =
      r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
  Widget emailField() => TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "输入邮箱地址",
        errorText: errorMap["emailE"] ? errorMap["email"] : null,
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1)),
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
        data["email"] = value;
        setState(() {});
      },
      controller: controllers['email']);
}
