import 'dart:async';
import 'dart:core';

import 'package:cabin/base/error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

class LocalData {
  static SharedPreferencesPlugin _spPlugin = SharedPreferencesPlugin();
  static SharedPreferencesPlugin get instance => _spPlugin;
  static dynamic obtainValue(String key) async {
    Map map = await _spPlugin.getAll();
    if (map.containsKey(key) == false)
      throw FrontError("LocalData", "OV_KEY_NULL");
    return map[key];
  }

  static Future<bool> containsKey(String key) async =>
      (await _spPlugin.getAll()).containsKey(key);

  static Future savePair(String key, dynamic value) async {
    String valueName;
    switch (value.runtimeType) {
      case int:
        valueName = "Int";
        break;
      case double:
        valueName = "Double";
        break;
      case bool:
        valueName = "Bool";
        break;
      case String:
        valueName = "String";
        break;
      case List:
        if (value is List<String>) valueName = "List<String>";
        break;
      default:
        throw FrontError("LocalData", "", "savePair(): Unsupported Type");
    }
    await _spPlugin.setValue(valueName, key, value);
  }
}

class IOClient {
  Dio dio;
  IOClient() {
    dio = new Dio();
    dio.options.baseUrl = 'http://www.qq.com'; //TODO: put url;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
  }

  Future<Map> communicateWith(
      {Map param, String target, String actionName, String method}) async {
    Response response;
    assert(method == "POST" || method == "GET");
    debugPrint("arrival");
    try {
      if (method == "POST")
        response = await dio.post(target, data: param);
      else if (method == "GET")
        response = await dio.get(target);
      else
        throw FrontError("IOClient", "METHOD NOT SUPPORTED");
    } on DioError catch (e) {
      throw BackError("IOClient", "DIO_ERROR", e.message);
    }
    if (response.statusCode == 200) {
      Map responseMap = response.data;
      if (responseMap.containsKey("success")) {
        if (responseMap["success"] is bool) {
          if (responseMap["success"] == true) {
            return responseMap;
          } else {
            if (responseMap.containsKey("exc")) {
              if (responseMap["exc"] is String)
                throw BackError("IOClient", responseMap["exc"]);
              else
                throw FrontError("IOClient", "EXC_TYPE_ERR");
            } else
              throw FrontError("IOClient", "EXC_NULL");
          }
        } else
          throw FrontError("IOClient", "SUC_TYPE_ERR");
      } else
        throw FrontError("IOClient", "SUC_NULL");
    } else {
      int code = response.statusCode;
      throw FrontError("IOClient", "HTTP_ERR_$code");
    }
  }
}

class LoginInfoProvider extends IOClient {
  Future<bool> login(String id, String password) async {
    debugPrint("here");
    Map map = new Map();
    map["id"] = id;
    map["password"] = password;
    Map response = await communicateWith(
        param: map, target: "/login/", actionName: "Login", method: "POST");
    if (response.containsKey("id") && response["id"] is String) {
      String temp = response["id"];
      if (temp.length == 0)
        throw FrontError("LoginInfoProvider", "PARAM_LENGTH_0");
      else
        LocalData.savePair("currentID", response["id"]);
    } else
      throw FrontError("LoginInfoProvider", "PARAM_NULL");

    if (response.containsKey("name") && response["name"] is String) {
      String temp = response["name"];
      if (temp.length == 0)
        throw FrontError("LoginInfoProvider", "PARAM_LENGTH_0");
      else
        LocalData.savePair("currentName", response["name"]);
    } else
      throw FrontError("LoginInfoProvider", "PARAM_NULL");

    if (response.containsKey("avatar") && response["avatar"] is String) {
      String temp = response["avatar"];
      if (temp.length == 0)
        throw FrontError("LoginInfoProvider", "PARAM_LENGTH_0");
      else
        LocalData.savePair("currentAvatar", response["avatar"]);
    } else
      throw FrontError("LoginInfoProvider", "PARAM_NULL");

    LocalData.savePair("currentPW", map["password"]);
    return true;
  }

  Future<dynamic> register(String name,String phone, String email, String password,
      int userType, int sex, int age) async {}

  Future<dynamic> passwordReset(String id, String password) async {}
}
