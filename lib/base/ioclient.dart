import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:cabin/base/error.dart';
import 'package:dio/adapter_browser.dart';
import 'package:dio/browser_imp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
// import 'package:http/http.dart' as http;

class IOClient {
  DioForBrowser dio;
  static String baseUrl = 'http://39.97.104.62/files';
  IOClient() {
    BaseOptions options = BaseOptions(
        baseUrl: 'http://39.97.104.62/api',
        connectTimeout: 5000,
        receiveTimeout: 3000,
        extra: {'withCredentials': true, 'credentials': true});
    dio = new DioForBrowser(options);
    var adapter = BrowserHttpClientAdapter();
    adapter.withCredentials = true;
    dio.httpClientAdapter = adapter;
  }

  static openContract() async {
    UrlLauncherPlugin plugin = UrlLauncherPlugin();
    if (await plugin.canLaunch(baseUrl + "/static/cabin_contract.pdf")) {
      plugin.openNewWindow(baseUrl + "/static/cabin_contract.pdf");
    }
  }

  Future<Map> communicateWith(
      {dynamic param, String target, String actionName, String method}) async {
    // http.Response response;
    Response response;
    assert(method == "POST" || method == "GET");

    try {
      if (method == "POST")
        response = await dio.post(target,
            data: param,
            options:
                Options(extra: {'withCredentials': true, 'credentials': true}));
      // response = (await http.post(base + target, body: json.encode(param)));
      else if (method == "GET")
        response = await dio.get(target,
            options:
                Options(extra: {'withCredentials': true, 'credentials': true}));
      // response = (await http.get(base + target));
      else
        throw FrontError("IOClient", "METHOD NOT SUPPORTED");
    } on DioError catch (e) {
      if (response != null)
        debugPrint(e.request.toString() +
            e.response.toString() +
            e.response.statusCode.toString());
      else
        debugPrint(e.toString());
      throw BackError(
        "IOClient",
        "DIO_ERROR",
      );
    }
    if (response.statusCode == 200) {
      Map responseMap = response.data;
      // Map responseMap = json.decode(response.body);
      if (responseMap.containsKey("success")) {
        if (responseMap["success"] is bool) {
          if (responseMap["success"] == true) {
            return responseMap;
          } else {
            if (responseMap.containsKey("exc")) {
              if (responseMap["exc"] is String)
                throw BackError(
                  "IOClient",
                  responseMap["exc"],
                );
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
