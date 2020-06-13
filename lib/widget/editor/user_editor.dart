import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/picture.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/editor/avatar_field.dart';
import 'package:cabin/widget/editor/custom_radio.dart';
import 'package:cabin/widget/editor/input_field.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class UserEditor extends StatefulWidget {
  User user;
  bool isAdmin;
  UserEditor(this.user, this.isAdmin);
  createState() => UserEditorState();
}

class UserEditorState extends State<UserEditor> {
  double _screenWidth;
  double _screenHeight;
  Map<String, CabinInputFieldController> controllers;
  Map<String, dynamic> values;
  bool isSubmitting = false;
  @override
  void initState() {
    super.initState();
    print(widget.user.toMap().toString());
    controllers = {
      "id": CabinInputFieldController(initValue: widget.user.id.toString()),
      "name": CabinInputFieldController(initValue: widget.user.name),
      "age": CabinInputFieldController(initValue: widget.user.age.toString()),
      "email": CabinInputFieldController(initValue: widget.user.email),
      "intro": CabinInputFieldController(initValue: widget.user.intro),
      "phone": CabinInputFieldController(initValue: widget.user.phone),
      "password": CabinInputFieldController(),
    };
    values = {
      "sex": widget.user.sex,
      "type": widget.user.type,
    };
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    return Center(
        child:  Card(
      elevation: 50,
      child: isSubmitting?SizedBox(height: 50,width: 50,child: CircularProgressIndicator(),): Container(
        width: 500,
        padding: EdgeInsets.all(30),
        child: ListView(shrinkWrap: true, children: list),
      ),
    ));
  }

  List<Widget> get list => <Widget>[
        BackButton(),
        avatarField(),
        idField(),
        nameField(),
        phoneField(),
        emailField(),
        introField(),
        ageField(),
        newPasswordField(),
        sexField(),
        typeField(),
        submitButton(),
      ];

  Widget avatarField() => CabinAvatarField(user: widget.user);
  Widget idField() => CabinInputField(
      title: "ID",
      enabled: false,
      makeErrorText: (value) => null,
      controller: controllers["id"]);
  Widget nameField() => CabinInputField(
    title: "昵称",
      makeErrorText: (value) {
        if (value.length > 20)
          return "长度不得超过20";
        else if (value.length == 0)
          return "不得留空";
        else
          return null;
      },
      hintText: "请输入姓名",
      controller: controllers["name"]);
  Widget phoneField() => CabinInputField(
    title: "手机号",
      enabled: widget.isAdmin,
      makeErrorText: (value) {
        if (value.contains("^[0-9]"))
          return "不得包含字符！";
        else if (value.length == 0)
          return "不得留空！";
        else if (value.length != 11)
          return "需要是11位数字！";
        else
          return null;
      },
      hintText: "请输入姓名",
      controller: controllers["phone"]);
  Widget emailField() => CabinInputField(
      title: "E-mail",
      makeErrorText: (value) {
        if (value.length == 0) {
          return "不得留空";
        } else if (!RegExp(regexEmail).hasMatch(value)) {
          return "格式错误";
        } else
          return null;
      },
      hintText: "请输入邮箱",
      controller: controllers["email"]);
  Widget introField() => CabinInputField(
    title: "简介",
      maxLines: 5,
      makeErrorText: (value) {
        if (value.length > 250)
          return "长度不得超过250";
        else if (value.length == 0)
          return "不得留空";
        else
          return null;
      },
      hintText: "请输入简介",
      controller: controllers["intro"]);
  Widget ageField() => CabinInputField(
    title: "年龄",
      makeErrorText: (value) {
        if (value.contains(RegExp(r'[^0-9]'))) {
          return "不得包含字符！";
        } else if (value.length < 1 || value.length > 3) {
          return "大小错误！";
        } else
          return null;
      },
      hintText: "请输入年龄",
      controller: controllers["age"]);
  Widget newPasswordField() =>widget.isAdmin?Container():CabinInputField(
    enabled: widget.isAdmin,
    title: "密码",
        makeErrorText: (value) {
          if (value.length < 6 || value.length > 16) {
            return "密码长度在6-16之间";
          } else if (!RegExp(regexPw).hasMatch(value)) {
            return "至少包含一个数字/大小写字母";
          } else
            return null;
        },
        hintText: "设置新密码",
        obscure: true,
      );
  Widget sexField() => CabinRadioField(
    enabled: widget.isAdmin,
        labels: ["男", "女"],
        values: <UserSex>[UserSex.male, UserSex.female],
        title: "性别",
        onChange: (sex) { values["sex"] = sex as UserSex; return;}
      );
  Widget typeField() => CabinRadioField(
    enabled: widget.isAdmin,
        labels: ["租客", "维修工人", "客服"],
        values: <UserType>[UserType.rentee, UserType.maintenance, UserType.service],
        title: "用户类别",
        onChange: (type) { values["type"] = type as UserType;return ;},
      );

  Widget submitButton() {
    return RaisedButton(
      onPressed: (){submit();},
      child: Text("提交修改"),
    );
  }

  Future submit()async{
    isSubmitting = true;
    setState(() {});
    controllers.forEach((key, controller) {
      if(controller.hasError){isSubmitting = false;return;}
    });
    if(isSubmitting == false){
      setState(() {});
      return;
    }
    User user = widget.user;
    user.age = int.parse(controllers["age"].text);
    user.intro = controllers["intro"].text;
    user.email = controllers["email"].text;
    user.phone = controllers["phone"].text;
    user.name = controllers["name"].text;
    user.password = controllers["password"].text;
    user.sex = values["sex"];
    user.type = values["type"];
    bool result = await UserProvider.instance.update(user);
    if(result == true){
      Toaster.showToast(title: "修改成功");
    }
    isSubmitting = false;
    setState(() {});
    return ;
  }
}
