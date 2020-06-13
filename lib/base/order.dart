import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cabin/base/ioclient.dart';
part 'order_provider.dart';

extension CabinDT on DateTime{
  String toMyString() { 
    String ret = this.toString();
    return this.toString().substring(0,ret.length<19?ret.length:19);}
  String toShortString() { 
    String ret = this.toString();
    return this.toString().substring(0,ret.length<10?ret.length:10);}
}

enum OrderStatus {
  submitted,
  unpaid,
  pendingReview,
  rejected,
  canceled,
  effective,
  over,
}

extension OrderStatusHelper on OrderStatus {
  int get value {
    switch (this) {
      case OrderStatus.submitted:
        return 1;
      case OrderStatus.unpaid:
        return 2;
      case OrderStatus.pendingReview:
        return 3;
      case OrderStatus.rejected:
        return 4;
      case OrderStatus.canceled:
        return 5;
      case OrderStatus.effective:
        return 6;
      case OrderStatus.over:
        return 7;
    }
  }

  String get title {
    switch (this) {
      case OrderStatus.submitted:
        return "已提交";
      case OrderStatus.unpaid:
        return "待付款";
      case OrderStatus.pendingReview:
        return "待审核";
      case OrderStatus.rejected:
        return "未通过";
      case OrderStatus.canceled:
        return "已取消";
      case OrderStatus.effective:
        return "已生效";
      case OrderStatus.over:
        return "已结束";
    }
  }

  static OrderStatus fromInt(int i) {
    switch (i) {
      case 1:
        return OrderStatus.submitted;
      case 2:
        return OrderStatus.unpaid;
      case 3:
        return OrderStatus.pendingReview;
      case 4:
        return OrderStatus.rejected;
      case 5:
        return OrderStatus.canceled;
      case 6:
        return OrderStatus.effective;
      case 7:
        return OrderStatus.over;
    }
  }
}

enum OrderType { short, long }

extension OrderTypeHelper on OrderType {
  int get value => this == OrderType.short ? 0 : 1;
  static OrderType fromInt(int i) =>
      i == 0 ? OrderType.short : i == 1 ? OrderType.long : null;
  String get title => this == OrderType.short ? "短租" : "长租";
  String get adv => this == OrderType.short ? "每晚" : "每月";
  bool get isShort => this.value == 0;
}

class Order extends CabinModel {
  int id;
  OrderStatus status;
  OrderType type;
  int amount;
  DateTime createTime;
  DateTime startTime;
  DateTime endTime;
  User rentee;
  House house;
  User respondant;

  Map toCommMap() => {
        'id': id,
        'status': status.value,
        'type': type.value,
        'amount': amount,
        'start': (startTime.toIso8601String()),
        'end': endTime.toIso8601String(),
        'uid': rentee.id,
        'hid': house.id,
        'rid': respondant==null?null:respondant.id,
      };
    Map toCreateMap() => {
        'type': type.value,
        'status':status.value,
        'amount': amount,
        'start': (startTime.toIso8601String()),
        'end': endTime.toIso8601String(),
        'uid': rentee.id,
        'hid': house.id,
      };
  Map toMap() => {
        'id': id,
        'status': status,
        'type': type,
        'amount': amount,
        'time': createTime,
        'start': startTime,
        'end': endTime,
        'uid': rentee,
        'hid': house,
        'res': respondant,
      };
  Order({
    @required this.id,
    @required this.status,
    @required this.type,
    @required this.amount,
    @required this.createTime,
    @required this.startTime,
    @required this.endTime,
    @required this.house,
    @required this.rentee,
    @required this.respondant,
  });
  Order.create(DateTime startTime,DateTime endTime,int uid,int hid,OrderType type,int amount){
    this.startTime = startTime;
    this.endTime = endTime;
    this.rentee = User.create(UserProvider.currentUser.id);
    this.rentee.id = uid;
    this.house = House.create();
    this.house.id = hid;
    this.type = type;
    this.amount = amount;
    this.status = this.type.isShort?
      OrderStatus.submitted:OrderStatus.pendingReview;
  }
  Order.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.status = OrderStatusHelper.fromInt(map["status"]);
    this.type = OrderTypeHelper.fromInt(map["type"]);
    this.amount = map["amount"];
    this.createTime = DateTime.parse(map["create"]);
    this.startTime = DateTime.parse(map["start"]);
    this.endTime = DateTime.parse(map["end"]);
    this.house = House.fromMap(map["house"]);
    this.rentee = User.fromMap(map["rentee"]);
    this.respondant = map["respondant"] == null?User.create(-1):User.fromMap(map["respondant"]);
  }

  static final List<String> fieldNames = [
    "ID",
    "状态",
    "类型",
    "金额",
    "创建时间",
    "开始时间",
    "结束时间",
    "房屋",
    "租客",
    "责任客服",
  ];

  List<String> suGetFieldNames() => fieldNames;
  List<String> getFieldNames() =>
      fieldNames.skipWhile((value) => value == "ID");

  static final Map<String, Comparator<CabinModel>> comparators = {
    fieldNames[0]: (CabinModel a, CabinModel b) => (a as Order).id - (b as Order).id,
    fieldNames[1]: (CabinModel a, CabinModel b) => (a as Order).status.value - (b as Order).status.value,
    fieldNames[2]: (CabinModel a, CabinModel b) => (a as Order).type.value - (b as Order).type.value,
    fieldNames[3]: (CabinModel a, CabinModel b) => (a as Order).amount - (b as Order).amount,
    fieldNames[4]: (CabinModel a, CabinModel b) => (a as Order).createTime.compareTo((b as Order).createTime),
    fieldNames[5]: (CabinModel a, CabinModel b) => (a as Order).startTime.compareTo((b as Order).createTime),
    fieldNames[6]: (CabinModel a, CabinModel b) => (a as Order).endTime.compareTo((b as Order).endTime),
    fieldNames[7]: (CabinModel a, CabinModel b) => (a as Order).house.id.compareTo((b as Order).house.id),
    fieldNames[8]: (CabinModel a, CabinModel b) => (a as Order).rentee.id - (b as Order).rentee.id,
    fieldNames[9]: (CabinModel a, CabinModel b) => (a as Order).respondant.id - (b as Order).respondant.id,
  };
  Map<String, Comparator<CabinModel>> getComparators() => comparators;

  double get priceInYuan => this.amount / 100;
  @override
  Map<String, Widget> getWidgets() => {
        fieldNames[0]: Text(this.id.toString()),
        fieldNames[1]: Text(this.status.title),
        fieldNames[2]: Text(this.type.toString()),
        fieldNames[3]: Text(this.priceInYuan.toString()),
        fieldNames[4]: Text(this.createTime.toString()),
        fieldNames[5]: Text(this.startTime.toString()),
        fieldNames[6]: Text(this.endTime.toString()),
        fieldNames[7]: this.house.cover,
        fieldNames[8]: this.rentee.avatarImage,
        fieldNames[9]: this.respondant.avatarImage,
      };
}
