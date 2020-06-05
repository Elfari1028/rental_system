import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/widgets.dart';

enum UserSex { male, female }

extension UserSexHelper on UserSex {
  int get value {
    switch (this) {
      case UserSex.female:
        return 0;
      default:
        return 1;
    }
  }

  String get name => this == UserSex.male ? "男" : "女";

  static UserSex fromInt(int i) {
    switch (i) {
      case 0:
        return UserSex.female;
      default:
        return UserSex.male;
    }
  }
}

enum UserType { rentee, service, maintenance }

extension UserTypeHelper on UserType {
  int get value {
    switch (this) {
      case UserType.rentee:
        return 1;
      case UserType.maintenance:
        return 2;
      default:
        return 3;
    }
  }

  String get name {
    switch (this) {
      case UserType.rentee:
        return "租客";
      case UserType.maintenance:
        return "维修工人";
      default:
        return "客服";
    }
  }

  static UserType fromInt(int i) {
    switch (i) {
      case 1:
        return UserType.rentee;
      case 2:
        return UserType.maintenance;
      default:
        return UserType.service;
    }
  }
}

class User extends CabinModel {
  int _id;
  int _age;
  String _name;
  String _phone;
  String _email;
  String _password;
  String _avatar;
  String _intro;
  UserSex _sex;
  UserType _type;

  int get id => _id;
  int get age => _age;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get password => _password;
  String get avatar => _avatar;
  String get intro => _intro;
  UserSex get sex => _sex;
  UserType get type => _type;

  static final List<String> fields = [
    "id",
    "phone",
    "email",
    "password",
    "avatar",
    "sex",
    "type",
    "intro",
    "age",
  ];

  static final List<String> fieldNames = [
    "ID",
    "头像",
    "手机号码",
    "Email",
    "密码",
    "sex",
    "type",
    "age",
    "intro"
  ];

  List<String> suGetFieldNames() => fieldNames;
  List<String> getFieldNames() => fieldNames; // 只有Respondent有权限，无所谓

  static final Map<String, Comparator<User>> comparators = {
    fieldNames[0]: (User a, User b) => a.id - b.id,
    fieldNames[1]: (User a, User b) => a.id - b.id,
    fieldNames[2]: (User a, User b) => a.phone.compareTo(b.phone),
    fieldNames[3]: (User a, User b) => a.email.compareTo(b.email),
    fieldNames[4]: (User a, User b) => a.password.compareTo(b.password),
    fieldNames[5]: (User a, User b) => a.sex.value - b.sex.value,
    fieldNames[6]: (User a, User b) => a.type.value - b.type.value,
    fieldNames[7]: (User a, User b) => a.age - b.age,
    fieldNames[8]: (User a, User b) => a.intro.length - b.intro.length,
  };

  Map<String, Comparator<CabinModel>> getComparators() => comparators;
  Map<String, Widget> getWidgets() => {
        fieldNames[0]: Text(this.id.toString()),
        fieldNames[1]: this.avatarImage,
        fieldNames[2]: Text(this.phone),
        fieldNames[3]: Text(this.email),
        fieldNames[4]: Text(this.password),
        fieldNames[5]: Text(this.sex.name),
        fieldNames[6]: Text(this.type.name),
        fieldNames[7]: Text(this.age.toString()),
        fieldNames[8]: Text(this.intro),
      };
  User({
    id = -1,
    @required name,
    @required phone,
    @required email,
    @required password,
    @required avatar,
    @required sex,
    @required type,
    @required intro,
    @required age,
  }) {
    this._name = name;
    this._phone = phone;
    this._email = email;
    this._password = password;
    this._avatar = _avatar;
    this._sex = sex;
    this._type = type;
    this._intro = intro;
    this._age = age;
  }

  User.fromMap(Map map) {
    if (map.isEmpty) throw FrontError("User", "INIT_MAP_NULL");
    fields.forEach((element) {
      if (!map.containsKey(element))
        throw FrontError("User", "INIT_MAP_NULL_PARAM", element);
    });
    _id = map["id"];
    _name = map["name"];
    _phone = map["phone"];
    _email = map["email"];
    _password = map["password"];
    _avatar = map["avatar"];
    _age = map["age"];
    _sex = UserSexHelper.fromInt(map["sex"]);
    _type = UserTypeHelper.fromInt(map["type"]);
    _intro = map["intro"];
  }

  Map toMap() {
    return <String, dynamic>{
      "id": this.id,
      "name": this.name,
      "email": this.email,
      "password": this.password,
      "phone": this.phone,
      "avatar": this.avatar,
      "sex": this.sex.value,
      "age": this.age,
      "type": this.type.value,
      "intro": this.intro,
    };
  }

  Image get avatarImage => this.avatar == "none"
      ? defaultAvatar
      : Image.network(this.avatar,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : Center(
                  child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                )));

  static Image get defaultAvatar => Image.asset(
        "images/avatar_default.jpg",
        fit: BoxFit.cover,
      );
  // List<String> toStringList() {
  //   List tmp = this.toMap().values;
  //   List<String> ret = List<String>();
  //   tmp.forEach((element) {
  //     if (element is UserSex) ret.add((element).value.toString());
  //     if (element is UserType)
  //       ret.add((element).value.toString());
  //     else
  //       ret.add(element.toString());
  //   });
  //   return ret;
  // }

  // User.fromStringList(List<String> list) {
  //   List keys = demoRentee.toMap().keys;
  //   Map map = Map.fromIterables(keys, list);
  //   User.fromMap(map);
  // }

  String toJson() {
    // print("encode" + json.encode(this.toMap()));

    return (json.encode(this.toMap()));
  }

  User.fromJson(String string) {
    print(json.decode(string.replaceAll("\\\"", "\"")));
    try {
      User.fromMap(json.decode(string.replaceAll("\\\"", "\"")));
    } catch (e) {
      throw FrontError("User", "FROM_JSON_FAIL", e.toString());
    }
  }

  static User demoRentee = User(
      name: "后浪",
      email: "rentee@buaa.edu.cn",
      phone: "18012345678",
      password: "ABCabc123",
      avatar:
          "http://5b0988e595225.cdn.sohucs.com/images/20171214/8dcf82e5ca244de19c5e404cb3bcedad.jpeg",
      sex: UserSex.male,
      type: UserType.rentee,
      age: 19,
      intro: "没有简介的少年..");
}

class UserProvider extends IOClient {
  static User _user;
  static User get currentUser => _user;
  static bool get loginStatus => (_user != null);
  static UserProvider _instance = UserProvider();

  static UserProvider get instance => _instance;

  Future<bool> tryGetMyInfo() async {
    Map response;
    bool result = true;
    try {
      response = await communicateWith(
          target: "account/get/", actionName: "Get My Info", method: "GET");
    } on BackError catch (e) {
      if (e.code == "ACCOUNT_NOT_LOGGEDIN") {
        result = false;
      } else
        throw e;
    }
    if (!result) {
      _user = null;
      return false;
    }
    if (!response.containsKey("data"))
      throw FrontError("UserProvider", "NULL_PARAM");
    if (!(response["data"] is Map))
      throw FrontError("UserProvider", "ERR_ARAM_TYPE");
    result = true;
    _user = User.fromMap(response["data"]);
    return true;
  }

  Future login(String id, String password) async {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["id"] = id;
    map["password"] = password;
    Map response = await communicateWith(
        param: map,
        target: "account/login/",
        actionName: "Login",
        method: "POST");

    if (!response.containsKey("data"))
      throw FrontError("LoginInfoProvider", "NULL_PARAM");
    if (!(response["data"] is Map))
      throw FrontError("LoginInfoProvider", "ERR,ARAM_TYPE");
    _user = User.fromMap(response["data"]);
  }

  Future<dynamic> register(User user) async {
    Map response = await communicateWith(
        param: user.toMap(),
        target: "account/register/",
        actionName: "register",
        method: "POST");
  }

  Future<List<User>> getAllUsers() async {
    Map response = await communicateWith(
        method: "GET", actionName: "Get All Users", target: "account/getall/");
    List<Map> usersMap = response["data"];
    List<User> ret = new List<User>();
    usersMap.forEach((element) {
      ret.add(User.fromMap(element));
    });
    return ret;
  }

  Future update(User user) async {
    await communicateWith(
        method: "POST",
        actionName: "UPDATE USER",
        param: user.toMap(),
        target: 'account/update/');
  }
}
