import 'package:flutter/material.dart';

import 'package:cabin/base/provider.dart';
import 'dart:async';

class House {
  int id;
  String title;
  int type;
  int status;
  String intro;
  String location;
  int price;
  List<String> imagePaths;

  House({
    this.id,
    this.title,
    this.type,
    this.status,
    this.intro,
    this.location,
    this.price,
    this.imagePaths,
  });

  String get capType {
    switch (type) {
      case -1:
      case 1:
        return "单人间";
      case 2:
      case -2:
        return "双人间";
      case 4:
      case -4:
        return "四人间";
    }
    return null;
  }

  String get rentType {
    return isShortTerm ? "短租" : "长租";
  }

  bool get isShortTerm {
    if (type == 1 || type == 2 || type == 4)
      return false;
    else if (type == -1 || type == -2 || type == 4)
      return true;
    else
      return null;
  }

  int get capacity {
    int temp = type;
    if (temp < 0) temp = -temp;
    if (temp == 1 || temp == 2 || temp == 4)
      return temp;
    else
      return null;
  }

  Image get cover {
    return Image.network(imagePaths.first,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) =>
            loadingProgress == null
                ? child
                : Center(
                    child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  )));
  }

  int get priceInYuan {
    return (price ~/ 100);
  }
}

class HouseProvider {
  static IOClient client = IOClient();
  static Future<List<House>> getRecommendations(int count) async {}
  static Future<List<House>> getAll() async {}
  static Future<List<House>> getWithKeyword(String str) async {
    List<String> keywords = str.split(' ');
  }

  static Future<List<House>> getDemoRecom() async {
    await Future.delayed(Duration(seconds: 1));
    return <House>[
      House(
        id: 1,
        title: "精品电梯公寓房——近地铁、商圈",
        type: 1,
        price: 20000,
        imagePaths: [
          "https://img.zcool.cn/community/0159e5578c30d50000018c1b4ecdbc.JPG@1280w_1l_2o_100sh.jpg"
        ],
      ),
      House(
        id: 2,
        title: "SlowTown | 音乐学院 | 共享居住空间",
        type: -2,
        price: 22000,
        imagePaths: [
          "http://5b0988e595225.cdn.sohucs.com/images/20190927/00728791e8b34b529c68715728d2325a.jpeg"
        ],
      ),
      House(
        id: 3,
        title: "青年商务单间",
        type: -1,
        price: 32000,
        imagePaths: ["https://i01piccdn.sogoucdn.com/8b533124cb0e7712"],
      ),
    ];
  }
}
