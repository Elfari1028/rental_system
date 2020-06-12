import 'package:cabin/base/house.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/user.dart';
import 'package:flutter/material.dart';

class CabinDisplayUtil {
  static Widget miniUserCard(User user,{double width}) => user.id == -1
      ? Text("空")
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
              Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: user.avatarImage)),
              Text("ID: " + user.id.toString(),
                  overflow: TextOverflow.ellipsis),
              Text("名称: " + user.name, softWrap: true, overflow: TextOverflow.ellipsis),
              Text("手机: " + user.phone,softWrap: true, overflow: TextOverflow.ellipsis),
              Text("E-mail: " + user.email,softWrap: true, overflow: TextOverflow.ellipsis)
            ]);
  static Widget miniOrderCard(Order order,{double width}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("ID: " + order.id.toString(),softWrap: true, overflow: TextOverflow.ellipsis),
            Text("订单状态：" + order.status.title, softWrap: true,overflow: TextOverflow.ellipsis),
            Text("创建时间: " + order.createTime.toMyString(),
                softWrap: true, overflow: TextOverflow.ellipsis),
            Text("金额: " + order.priceInYuan.toString() + "元",softWrap: true,
                overflow: TextOverflow.ellipsis),
          ]);
  static Widget miniHouseCard(House house,{double width}) =>Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: house.cover)),
            Text("ID: " + house.id.toString(), softWrap: true,overflow: TextOverflow.ellipsis),
            Text("标题: " + house.title,
                softWrap: true, overflow: TextOverflow.ellipsis),
            Text("地址: " + house.location,
                softWrap: true, overflow: TextOverflow.ellipsis)
          ]);
}
