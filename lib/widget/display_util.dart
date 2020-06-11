import 'package:cabin/base/house.dart';
import 'package:cabin/base/user.dart';
import 'package:flutter/material.dart';

class CabinDisplayUtil{
  static Widget miniUserCard(User user) => user.id == -1
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
              Text("名称: " + user.name, overflow: TextOverflow.ellipsis),
              Text("手机: " + user.phone, overflow: TextOverflow.ellipsis),
              Text("E-mail: " + user.email, overflow: TextOverflow.ellipsis)
            ]);
  static Widget miniHouseCard(House house) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: house.cover)),
            Text("ID: " + house.id.toString(), overflow: TextOverflow.ellipsis),
            Text("标题: " + house.title,
                softWrap: false, overflow: TextOverflow.ellipsis),
            Text("地址: " + house.location,
                softWrap: true, overflow: TextOverflow.ellipsis)
          ]);
}