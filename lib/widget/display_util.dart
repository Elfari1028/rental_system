import 'package:cabin/base/house.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/user.dart';
import 'package:flutter/material.dart';

class CabinDisplayUtil {
  static Widget miniUserCard(User user, {double width}) => user.id == -1
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
             Wrap(
               children:[ Text("ID: " + user.id.toString(),
                  ),
               Text("名称: " + user.name,
                   softWrap: true,)]),Wrap(children: [
               Text("手机: " + user.phone,
                   softWrap: true,)]),Wrap(children: [
               Text("E-mail: " + user.email,
                   softWrap: true,)])
            ]);
  static Widget miniOrderCard(Order order, {double width}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Wrap(children: [
              Text("ID: " + order.id.toString(),
                  softWrap: true, )]),Wrap(children: [
              Text("订单状态：" + order.status.title,
                  softWrap: true, )]),Wrap(children: [
              Text("创建时间: " + order.createTime.toMyString(),
                  softWrap: true,)]),Wrap(children: [
              Text("金额: " + order.priceInYuan.toString() + "元",
                  softWrap: true, ),
            ]),
          ]);
  static Widget miniHouseCard(House house, {double width}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: house.cover)),
           Wrap(
             children:[ Text("ID: " + house.id.toString(),
                 )]),Wrap(children: [
             Text("标题: " + house.title,
                  )]),Wrap(children: [
             Text("地址: " + house.location,
                 )
             ])
          ]);
}
