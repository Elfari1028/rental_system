import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

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

class Order extends CabinModel {
  int id;
  OrderStatus status;
  int type;
  int amount;
  DateTime createTime;
  DateTime startTime;
  DateTime endTime;
  User rentee;
  House house;
  User respondant;

  Map toMap() => {
        'id': id,
        'status': status,
        'type': type,
        'amount': amount,
        'time': createTime,
        'start': startTime,
        'end': endTime,
        'uid': rentee.id,
        'hid': house.id,
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

  Order.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.status = map["status"];
    this.type = map["type"];
    this.amount = map["amount"];
    this.createTime = map["create"];
    this.startTime = map["start"];
    this.endTime = map["end"];
    this.house = House.fromMap(map["house"]);
    this.rentee = User.fromMap(map["rentee"]);
    this.respondant = User.fromMap(map["respondant"]);
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

  static final Map<String, Comparator<Order>> comparators = {
    fieldNames[0]: (Order a, Order b) => a.id - b.id,
    fieldNames[1]: (Order a, Order b) => a.status.value - b.status.value,
    fieldNames[2]: (Order a, Order b) => a.type - b.type,
    fieldNames[3]: (Order a, Order b) => a.amount - b.amount,
    fieldNames[4]: (Order a, Order b) => a.createTime.compareTo(b.createTime),
    fieldNames[5]: (Order a, Order b) => a.startTime.compareTo(b.createTime),
    fieldNames[6]: (Order a, Order b) => a.endTime.compareTo(b.endTime),
    fieldNames[7]: (Order a, Order b) => a.house.id.compareTo(b.house.id),
    fieldNames[8]: (Order a, Order b) => a.rentee.id - b.rentee.id,
    fieldNames[9]: (Order a, Order b) => a.respondant.id - b.respondant.id,
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
