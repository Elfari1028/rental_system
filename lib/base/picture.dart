import 'dart:typed_data';

import 'package:cabin/base/error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:universal_html/html.dart' as html;

class Picture {
  Image image;
  html.File file;
  Uint8List imageBytes;
  String imageName;
}

class PictureGroupProvider extends IOClient {
  static PictureGroupProvider _instance = PictureGroupProvider();
  static PictureGroupProvider get instance => _instance;

  Future<String> uploadAvatar(Picture avatar) async {
    FormData formData = FormData.fromMap({
      "avatar":
          MultipartFile.fromBytes(avatar.imageBytes, filename: avatar.imageName)
    });
    Map response = await communicateWith(
        method: "POST",
        actionName: "UPLOAD PICTURE",
        target: "/account/avatar/",
        param: formData);
    return response["data"];
  }

  Future<int> upload(List<Picture> pictures) async {
    List<MultipartFile> files = List<MultipartFile>();
    pictures.forEach((element) {
      files.add(MultipartFile.fromBytes(element.imageBytes,
          filename: element.imageName));
    });
    FormData formData = FormData.fromMap({"image": files});
    Map response = await communicateWith(
        method: "POST",
        actionName: "UPLOAD PICTURE",
        target: "/picgroup/upload/",
        param: formData);
    int id = response["id"];
    return id;
  }

  Future append(int pgid, int start, List<Picture> pictures) async {
    List<MultipartFile> files = List<MultipartFile>();
    pictures.forEach((element) {
      files.add(MultipartFile.fromBytes(element.imageBytes,
          filename: element.imageName));
    });
    FormData formData =
        FormData.fromMap({"start": start, "id": pgid, "files": files});
    Map response = await communicateWith(
        method: "POST",
        actionName: "UPLOAD PICTURE",
        target: "/picgroup/append/",
        param: formData);
  }

  Future remove(int pid, int pgid, int len) async {
    Map response = await communicateWith(
        method: "POST",
        actionName: "UPLOAD PICTURE",
        target: "/picgroup/remove/",
        param: {"pgid": pgid, "id": pid,"len":len});
  }

  Future delete(int pgid) async {
    Map response = await communicateWith(
        method: "POST",
        actionName: "UPLOAD PICTURE",
        target: "/picgroup/delete/",
        param: {"pgid": pgid});
  }

  static Future<Picture> pickFile() async {
    Picture ret = new Picture();
    try {
      final Map<String, dynamic> data = {};
      final html.FileUploadInputElement input = html.FileUploadInputElement();
      input..accept = 'image/*';
      input.click();
      await input.onChange.first;
      if (input.files.isEmpty) return null;
      ret.file = input.files.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      await reader.onLoad.first;
      final encoded = reader.result as String;
      final stripped =
          encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
      ret.imageName = input.files?.first?.name;
      data.addAll(
          {'name': ret.imageName, 'data': stripped, 'data_scheme': encoded});
      final imageData = base64.decode(data['data']);
      ret.imageBytes = imageData;
      ret.image = Image.memory(imageData, semanticLabel: ret.imageName);
    } catch (e) {
      ret = null;
    }
    return ret;
  }
}
