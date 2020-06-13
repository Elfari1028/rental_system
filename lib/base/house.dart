import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/picture.dart';
import 'package:flutter/material.dart';
import 'package:cabin/base/ioclient.dart';

import 'dart:async';


part 'house_provider.dart';

enum HouseStatus { normal, suspended }

extension HouseStatusHelper on HouseStatus {
  int get value => this == HouseStatus.normal ? 1 : 2;
  String get title => this == HouseStatus.normal ? "开放申请" : "暂停出租";
  static HouseStatus fromInt(int i) =>
      i == 1 ? HouseStatus.normal : HouseStatus.suspended;
}
enum HouseCapacity {
  mono,
  bi,
  quad,
}

extension HouseCapcacityeHelper on HouseCapacity {
  int get value {
    switch (this) {
      case HouseCapacity.mono:
        return 1;
      case HouseCapacity.bi:
        return 2;
      case HouseCapacity.quad:
        return 4;
    }
  }

  static HouseCapacity fromInt(int i) {
    switch (i) {
      case 1:
        return HouseCapacity.mono;
      case 2:
        return HouseCapacity.bi;
      case 4:
        return HouseCapacity.quad;
      default:
        return null;
    }
  }

  String get title {
    switch (this) {
      case HouseCapacity.mono:
        return "单人间";
      case HouseCapacity.bi:
        return "双人间";
      case HouseCapacity.quad:
        return "四人间";
    }
  }
}

enum HouseTerm { short, long }

extension HouseTermHelper on HouseTerm {
  int get value => this == HouseTerm.short ? 0 : 1;
  static HouseTerm fromInt(int i) =>
      i == 0 ? HouseTerm.short : i == 1 ? HouseTerm.long : null;
  String get title => this == HouseTerm.short ? "短租" : "长租";
  String get adv => this == HouseTerm.short ? "每晚" : "每月";
  bool get isShort => this.value == 0;
}

class House extends CabinModel {
  int id;
  String title;
  HouseCapacity capacity;
  HouseTerm term;
  HouseStatus status;
  String intro;
  String location;
  int price;
  int pictureGroupID;
  List<String> imagePaths;

  House({
    @required this.id,
    @required this.title,
    @required this.term,
    @required this.capacity,
    @required this.status,
    @required this.intro,
    @required this.location,
    @required this.price,
    @required this.pictureGroupID,
    @required this.imagePaths,
  });

  House.create() {
    this.id = -1;
    this.title = "title";
    this.term = HouseTerm.short;
    this.capacity = HouseCapacity.bi;
    this.intro = "intro";
    this.location = "location";
    this.price = 100000;
    this.status = HouseStatus.normal;
    this.pictureGroupID = -1;
    this.imagePaths = [];
  }
  static final List<String> fieldNames = [
    "ID",
    "标题",
    "类型",
    "周期",
    "状态",
    "介绍",
    "地址",
    "价格",
    "图片",
  ];

  List<String> suGetFieldNames() => fieldNames;
  List<String> getFieldNames() => fieldNames;

  static final Map<String, Comparator<CabinModel>> comparators =
      <String, Comparator<CabinModel>>{
    fieldNames[0]: (CabinModel a, CabinModel b) =>
        (a as House).id - (b as House).id,
    fieldNames[1]: (CabinModel a, CabinModel b) =>
        (a as House).title.compareTo((b as House).title),
    fieldNames[2]: (CabinModel a, CabinModel b) =>
        (a as House).capacity.value - (b as House).capacity.value,
    fieldNames[3]: (CabinModel a, CabinModel b) =>
        (a as House).term.value - (b as House).term.value,
    fieldNames[4]: (CabinModel a, CabinModel b) =>
        (a as House).status.value - (b as House).status.value,
    fieldNames[5]: (CabinModel a, CabinModel b) =>
        (a as House).intro.length - (b as House).intro.length,
    fieldNames[6]: (CabinModel a, CabinModel b) =>
        (a as House).location.compareTo((b as House).location),
    fieldNames[7]: (CabinModel a, CabinModel b) =>
        (a as House)._pricePerDay.compareTo((b as House)._pricePerDay),
    fieldNames[8]: (CabinModel a, CabinModel b) =>
        (a as House).imagePaths.length - (b as House).imagePaths.length,
  };

  Map<String, Comparator<CabinModel>> getComparators() => comparators;
  Map<String, Widget> getWidgets() => {
        fieldNames[0]: Text(
          this.id.toString(),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        fieldNames[1]: Text(
          this.title,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        fieldNames[2]: Text(
          this.capacity.title,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        fieldNames[3]: Text(
          this.term.title,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        fieldNames[4]: Text(
          this.status.title,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        fieldNames[5]: Text(
          this.intro,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        fieldNames[6]: Text(
          this.location,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        fieldNames[7]: Text(
          this.priceInYuan.toString(),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        fieldNames[8]: this.cover,
      };

  Map toMap() => {
        "id": id,
        "title": title,
        "cap": capacity.value,
        "term": term.value,
        "status": status.value,
        "intro": intro,
        "location": location,
        "price": price,
        "pgid": pictureGroupID,
      };

  House.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.term = HouseTermHelper.fromInt(map["term"]);
    this.capacity = HouseCapcacityeHelper.fromInt(map["cap"]);
    this.status = HouseStatusHelper.fromInt(map["status"]);
    imagePaths = new List<String>();
    List images = (map["images"] as List);
    for(int i = 0 ; i < images.length ; i++)
      this.imagePaths.add(IOClient.baseUrl + (images[i] as String));
    this.pictureGroupID = map["pgid"];
    this.price = map["price"];
    this.location = map["location"];
    this.intro = map["intro"];
  }

  double get _pricePerDay => this.term.isShort ? this.price : this.price / 30;

  Image get cover {
    return Image.network(imagePaths.first,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) =>
            loadingProgress == null
                ? child
                : Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator())));
  }

  List<Image> get images {
    List<Image> images = List<Image>();
    this.imagePaths.forEach((element) {
      images.add(Image.network(element,
          fit: BoxFit.fitWidth,
          loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) =>
              loadingProgress != null
                  ? Center(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()))
                  : child));
    });
    return images;
  }

  int get priceInYuan {
    return (price ~/ 100);
  }

  void suspend() async {
    HouseProvider provider = HouseProvider.instance;
    bool result = await provider.suspend(this.id);
    if (result = true) this.status = HouseStatus.suspended;
  }
}

