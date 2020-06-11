import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/ioclient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart';

part 'user_provider.dart';

final String regexEmail =
    r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
final String regexPw = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';

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
  int id = -1;
  int age;
  String name;
  String phone;
  String email;
  String password;
  String avatar;
  String intro;
  UserSex sex;
  UserType type;

  User.create(int id){
    this.id = id;
  }
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
    "昵称",
    "手机号码",
    "Email",
    "密码",
    "性别",
    "类型",
    "年龄",
    "介绍"
  ];

  List<String> suGetFieldNames() => fieldNames;
  List<String> getFieldNames() => fieldNames; // 只有Respondent有权限，无所谓

  static final Map<String, Comparator<CabinModel>> comparators = {
    fieldNames[0]: (CabinModel a, CabinModel b) => (a as User).id - (b as User).id,
    fieldNames[1]: (CabinModel a, CabinModel b) => (a as User).id - (b as User).id,
    fieldNames[2]: (CabinModel a, CabinModel b) => (a as User).name.compareTo((b as User).name),
    fieldNames[3]: (CabinModel a, CabinModel b) => (a as User).phone.compareTo((b as User).phone),
    fieldNames[4]: (CabinModel a, CabinModel b) => (a as User).email.compareTo((b as User).email),
    fieldNames[5]: (CabinModel a, CabinModel b) => (a as User).password.compareTo((b as User).password),
    fieldNames[6]: (CabinModel a, CabinModel b) => (a as User).sex.value - (b as User).sex.value,
    fieldNames[7]: (CabinModel a, CabinModel b) => (a as User).type.value - (b as User).type.value,
    fieldNames[8]: (CabinModel a, CabinModel b) => (a as User).age - (b as User).age,
    fieldNames[9]: (CabinModel a, CabinModel b) => (a as User).intro.length - (b as User).intro.length,
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
    @required String name,
    @required String phone,
    @required String email,
    @required String password,
    @required String avatar,
    @required UserSex sex,
    @required UserType type,
    @required String intro,
    @required int age,
  }) {
    this.name = name;
    this.phone = phone;
    this.email = email;
    this.password = password;
    this.avatar = avatar;
    this.sex = sex;
    this.type = type;
    this.intro = intro;
    this.age = age;
  }

  User.fromMap(Map map) {
    if (map.isEmpty) throw FrontError("User", "INIT_MAP_NULL");
    fields.forEach((element) {
      if (!map.containsKey(element))
        throw FrontError("User", "INIT_MAP_NULL_PARAM", element);
    });
    id = map["id"];
    name = map["name"];
    phone = map["phone"];
    email = map["email"];
    password = map["password"];
    avatar =
        map["avatar"] == "none" ? "none" : IOClient.baseUrl + map["avatar"];
    age = map["age"];
    sex = UserSexHelper.fromInt(map["sex"]);
    type = UserTypeHelper.fromInt(map["type"]);
    intro = map["intro"];
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

  set newAvatar(String nAvatar) => this.avatar = nAvatar;

  String toJson() {
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