import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/picture.dart';
import 'package:cabin/base/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cabin/base/ioclient.dart';
part 'support_request_provider.dart';

enum RequestStatus {
  pending,
  ongoing,
  dispatched,
  closed,
  rated,
}

extension RequestStatusHelper on RequestStatus {
  int get value {
    switch (this) {
      case RequestStatus.pending:
        return 1;
      case RequestStatus.ongoing:
        return 2;
      case RequestStatus.dispatched:
        return 3;
      case RequestStatus.closed:
        return 4;
      case RequestStatus.rated:
        return 4;
    }
  }

  String get title {
    switch (this) {
      case RequestStatus.pending:
        return "等待处理";
      case RequestStatus.ongoing:
        return "处理中";
      case RequestStatus.dispatched:
        return "已安排维修";
      case RequestStatus.closed:
        return "已关闭";
      case RequestStatus.rated:
        return "已评价";
    }
  }

  static RequestStatus fromInt(int i) {
    switch (i) {
      case 1:
        return RequestStatus.pending;
      case 2:
        return RequestStatus.ongoing;
      case 3:
        return RequestStatus.dispatched;
      case 4:
        return RequestStatus.closed;
    }
  }
}

enum RequestType { maintenance, report }

extension RequestTypeHelper on RequestType {
  int get value => this == RequestType.maintenance ? 0 : 1;
  static RequestType fromInt(int i) =>
      i == 0 ? RequestType.maintenance : i == 1 ? RequestType.report : null;
  String get title => this == RequestType.maintenance ? "报修" : "投诉";
  bool get isMaintenance => this.value == 0;
}

class SupportRequest extends CabinModel {
  int id;
  RequestStatus status;
  RequestType type;
  String content;
  DateTime createTime;
  int pictureGroupID;
  List<String> imagePaths;
  Order order;
  User rentee;
  User maintenance;
  User respondant;

  SupportRequest.fromMap(Map map) {
    this.id = map["id"];
    this.status = RequestStatusHelper.fromInt(map['status']);
    this.type = RequestTypeHelper.fromInt(map['type']);
    this.content = map['content'];
    this.pictureGroupID = map['pgid'];
    List images = (map["images"] as List);
    this.imagePaths = new List<String>();
    for (int i = 0; i < images.length; i++)
      this.imagePaths.add(IOClient.baseUrl + (images[i] as String));
    this.createTime = DateTime.parse(map['create']);
    this.order = Order.fromMap(map['order']);
    this.rentee = User.fromMap(map['rentee']);
    this.maintenance = map['maintenance'] == null
        ? User.create(-1)
        : User.fromMap(map['maintenance']);
    this.respondant = map['respondant'] == null
        ? User.create(-1)
        : User.fromMap(map['respondant']);
  }

  Map toCreateMap() => {
        'uid': rentee.id,
        'order': order.id,
        'content': content,
        'type': type.value,
        'status': 1,
        'pgid': pictureGroupID,
      };

  SupportRequest.create(
      User user, Order order, String content, RequestType type) {
    status = RequestStatus.pending;
    this.type = type;
    this.content = content;
    this.rentee = user;
    this.order = order;
  }

  static final List<String> fieldNames = [
    "ID",
    "状态",
    "类型",
    "内容",
    "创建时间",
    "图片",
    "订单",
    "房屋",
    "租客",
    "维修工人",
    "责任客服",
  ];

  static final Map<String, Comparator<CabinModel>> comparators = {
    fieldNames[0]: (CabinModel a, CabinModel b) =>
        (a as SupportRequest).id - (b as SupportRequest).id,
    fieldNames[1]: (CabinModel a, CabinModel b) =>
        (a as SupportRequest).status.value - (b as SupportRequest).status.value,
    fieldNames[2]: (CabinModel a, CabinModel b) =>
        (a as SupportRequest).type.value - (b as SupportRequest).type.value,
    fieldNames[3]: (CabinModel a, CabinModel b) =>
        (a as SupportRequest).content.length -
        (b as SupportRequest).content.length,
    fieldNames[4]: (CabinModel a, CabinModel b) => (a as SupportRequest)
        .createTime
        .compareTo((b as SupportRequest).createTime),
    fieldNames[5]: (CabinModel a, CabinModel b) =>
        (a as SupportRequest).imagePaths.length -
        (b as SupportRequest).imagePaths.length,
    fieldNames[6]: (CabinModel a, CabinModel b) => (a as SupportRequest)
        .order
        .id
        .compareTo((b as SupportRequest).order.id),
         fieldNames[7]: (CabinModel a, CabinModel b) => (a as SupportRequest)
        .order.house.id
        .compareTo((b as SupportRequest).order.house.id),
    fieldNames[8]: (CabinModel a, CabinModel b) =>
        (a as SupportRequest).rentee.id - (b as SupportRequest).rentee.id,
    fieldNames[9]: (CabinModel a, CabinModel b) =>
        (a as SupportRequest).maintenance.id -
        (b as SupportRequest).maintenance.id,
    fieldNames[10]: (CabinModel a, CabinModel b) =>
        (a as SupportRequest).respondant.id -
        (b as SupportRequest).respondant.id,
  };

  @override
  Map<String, Comparator<CabinModel>> getComparators() => comparators;

  @override
  List<String> getFieldNames() => fieldNames;

  @override
  List<String> suGetFieldNames() => fieldNames;

  @override
  Map<String, Widget> getWidgets() => {
        // fieldNames[0]: Text(this.id.toString()),
        // fieldNames[1]: Text(this.status.title),
        // fieldNames[2]: Text(this.type.title),
        // fieldNames[3]: Text(this.content,overflow: TextOverflow.ellipsis,),
        // fieldNames[4]: Text(this.createTime.toString()),
        // fieldNames[5]: Image.network(this.imagePaths.first),
        // fieldNames[6]: this.order..cover,
        // fieldNames[7]: this.rentee.avatarImage,
        // fieldNames[8]: this.maintenance == null?Text("无"):this.maintenance.avatarImage,
        // fieldNames[9]: this.respondant == null?Text("无"):this.respondant.avatarImage,
      };

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
          fit: BoxFit.cover,
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
}

class SupportRequestReply implements Comparable<SupportRequestReply> {
  int id;
  int srid;
  User user;
  DateTime time;
  String content;
  int pictureGroupID;
  List<String> imagePaths;

  Map toCreateMap() => {
        "srid": srid,
        "user": user.id,
        "content": content,
        "pgid": pictureGroupID,
      };

  @override
  int compareTo(SupportRequestReply other) {
    return this.time.compareTo(other.time);
  }

  SupportRequestReply.fromMap(Map map) {
    this.id = map["id"];
    this.srid = map["srid"];
    this.user = User.fromMap(map["user"]);
    this.pictureGroupID = map["pgid"] == null? -1:map["pgid"];
    this.content = map["content"];
    this.time = DateTime.parse(map['time']);
    List images = (map["images"] as List);
    this.imagePaths = new List<String>();
    if(map["images"]!=null)
    for (int i = 0; i < images.length; i++)
      this.imagePaths.add(IOClient.baseUrl + (images[i] as String));
  }

  SupportRequestReply.create(int srid,User user, String content) {
    this.srid = srid;
    this.user =user;
    this.content = content;
  }
}
