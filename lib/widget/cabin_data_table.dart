import 'dart:js_util';

import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/support_request.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/display_util.dart';
import 'package:flutter/material.dart';

class CabinDataTable extends StatefulWidget {
  final List<CabinModel> items;
  final UserType userType;
  CabinDataTable({@required this.items, @required this.userType});
  createState() => userType == UserType.rentee
      ? RenteeCabinDataTableState()
      : userType == UserType.maintenance
          ? MaintenanceCabinDataTableState()
          : ServiceCabinDataTableState();
}

class RenteeCabinDataTableState extends CabinDataTableState {
  @override
  Widget houseActions(House house) {
    throw UnimplementedError();
  }

  @override
  Widget orderActions(Order order) {
    List<Widget> ret = new List<Widget>();
    if (order.status == OrderStatus.pendingReview ||
        order.status == OrderStatus.submitted ||
        order.status == OrderStatus.unpaid)
      ret.add(RaisedButton(
          onPressed: () {}, color: Colors.red, child: Text("取消订单")));
    if (order.status == OrderStatus.unpaid)
      ret.add(RaisedButton(onPressed: () {}, child: Text("付款")));
    if (order.status == OrderStatus.pendingReview && !order.type.isShort)
      ret.add(RaisedButton(onPressed: () {}, child: Text("打印合同")));
    if (order.status == OrderStatus.effective) {
      ret.add(RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/support/create',
                arguments: {'order': order, 'init': RequestType.report});
          },
          child: Text("投诉")));
      ret.add(RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/support/create',
                arguments: {'order': order, 'init': RequestType.maintenance});
          },
          child: Text("报修")));
    }
    if (!order.type.isShort &&
        order.status == OrderStatus.effective &&
        order.endTime.difference(DateTime.now()).inDays <= 7)
      ret.add(RaisedButton(onPressed: () {}, child: Text("续费")));
    return Column(children: ret);
  }

  @override
  Widget requestActions(SupportRequest request) {
    List<Widget> ret = new List<Widget>();
    if (request.status != RequestStatus.closed) {
      ret.add(RaisedButton(
          onPressed: () {}, color: Colors.green, child: Text("回复")));
      ret.add(RaisedButton(onPressed: () {}, child: Text("关闭工单")));
    } else
      ret.add(RaisedButton(onPressed: () {}, child: Text("查看详情")));
    return Column(children: ret);
  }

  @override
  Widget userActions(User user) {
    throw UnimplementedError();
  }
}

class MaintenanceCabinDataTableState extends CabinDataTableState {
  @override
  Widget houseActions(House house) {
    throw UnimplementedError();
  }

  @override
  Widget orderActions(Order order) {
    throw UnimplementedError();
  }

  @override
  Widget requestActions(SupportRequest request) {
    List<Widget> ret = new List<Widget>();
    if (request.status != RequestStatus.closed) {
      ret.add(RaisedButton(
          onPressed: () {}, color: Colors.green, child: Text("回复")));
    } else
      ret.add(RaisedButton(onPressed: () {}, child: Text("查看详情")));
    return Column(
      children: ret,
    );
  }

  @override
  Widget userActions(User user) {
    throw UnimplementedError();
  }
}

class ServiceCabinDataTableState extends CabinDataTableState {
  @override
  Widget houseActions(House house) {
    List<Widget> ret = new List<Widget>();
    ret.add(RaisedButton(
        onPressed: () async {
          await Navigator.of(context)
              .pushNamed('/house/edit', arguments: {'house': house});
        },
        child: Text("修改")));
    return Column(children: ret);
  }

  @override
  Widget orderActions(Order order) {
    List<Widget> ret = new List<Widget>();
    ret.add(RaisedButton(onPressed: () {}, child: Text("修改")));
    if (order.status.value <= 3) {
      ret.add(RaisedButton(
          onPressed: () {}, color: Colors.green, child: Text("通过申请")));
      ret.add(RaisedButton(
          onPressed: () {}, color: Colors.red, child: Text("拒绝申请")));
    }
    if (order.status == OrderStatus.pendingReview && !order.type.isShort)
      ret.add(RaisedButton(onPressed: () {}, child: Text("打印合同")));
    return Column(children: ret);
  }

  @override
  Widget requestActions(SupportRequest request) {
    List<Widget> ret = new List<Widget>();
    if (request.status != RequestStatus.closed) {
      ret.add(RaisedButton(
          onPressed: () {}, color: Colors.red, child: Text("关闭工单")));
      ret.add(RaisedButton(
          onPressed: () {}, color: Colors.green, child: Text("回复")));
    } else
      ret.add(RaisedButton(onPressed: () {}, child: Text("查看详情")));
    return Column(
      children: ret,
    );
  }

  @override
  Widget userActions(User user) {
    List<Widget> ret = new List<Widget>();
    ret.add(RaisedButton(
        onPressed: () async {
          await Navigator.of(context)
              .pushNamed('/account/edit', arguments: {'user': user});
        },
        child: Text("修改")));
    return Column(children: ret);
  }
}

abstract class CabinDataTableState extends State<CabinDataTable> {
  double _screenWidth;
  double frameWidth;

  List<CabinModel> items;
  Map<String, Comparator<CabinModel>> comparators;
  List<String> fieldNames;
  int _sortColumnIndex;
  bool _sortAsc = true;
  @override
  void initState() {
    super.initState();
    items = widget.items;
    fieldNames = items.first.suGetFieldNames();
    comparators = items.first.getComparators();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    frameWidth = _screenWidth * 0.8 > 800 ? _screenWidth * 0.8 : 800;
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: body());
  }

  Widget body() {
    return DataTable(
      dataRowHeight: 250,
      columns: myColumns,
      rows: myRows,
      columnSpacing: 15,
      sortAscending: _sortAsc,
      sortColumnIndex: _sortColumnIndex,
    );
  }

  List<DataColumn> get myColumns {
    List<DataColumn> ret = new List<DataColumn>();
    ret.add(DataColumn(label: Text("操作")));
    for (int i = 0; i < fieldNames.length; i++) {
      ret.add(DataColumn(
          label: text(fieldNames[i]),
          onSort: (columnIndex, ascending) {
            onSort(i, columnIndex, ascending);
          }));
    }
    return ret;
  }

  void onSort(int i, int index, bool ascending) {
    setState(() {
      _sortAsc = ascending;
      _sortColumnIndex = index;
      items.sort(comparators[fieldNames[i]]);
      if (!ascending) items = items.reversed.toList();
    });
  }

  Widget userActions(User user);
  Widget houseActions(House house);
  Widget orderActions(Order order);
  Widget requestActions(SupportRequest request);

  List<DataRow> get userRows => items
      .map((user) => DataRow(cells: [
            wrapper(userActions(user as User), null),
            wrapper(text((user as User).id.toString()), () {}),
            wrapper((user as User).avatarImage, () {}),
            wrapper(text((user as User).name), () {}),
            wrapper(text((user as User).phone), () {}),
            wrapper(text((user as User).email), () {}),
            wrapper(text("********"), () {}),
            wrapper(text((user as User).sex.name), () {}),
            wrapper(text((user as User).type.name), () {}),
            wrapper(text((user as User).age.toString()), () {}),
            wrapper(text((user as User).intro), () {}),
          ]))
      .toList();

  List<DataRow> get orderRows => items
      .map((order) => DataRow(cells: [
            wrapper(orderActions(order as Order), null),
            wrapper(text((order as Order).id.toString()), () {}),
            wrapper(text((order as Order).status.title), () {}),
            wrapper(text((order as Order).type.title), () {}),
            wrapper(text((order as Order).priceInYuan.toString() + "元"), () {}),
            wrapper(text((order as Order).createTime.toMyString()), () {}),
            wrapper(text((order as Order).startTime.toMyString()), () {}),
            wrapper(text((order as Order).endTime.toMyString()), () {}),
            wrapper(
                CabinDisplayUtil.miniHouseCard((order as Order).house), () {}),
            wrapper(
                CabinDisplayUtil.miniUserCard((order as Order).rentee), () {}),
            wrapper(CabinDisplayUtil.miniUserCard((order as Order).respondant),
                () {}),
          ]))
      .toList();

  List<DataRow> get houseRows => items
      .map((house) => DataRow(cells: [
            wrapper(houseActions(house as House), null),
            wrapper(text((house as House).id.toString()), () {}),
            wrapper(text((house as House).title), () {}),
            wrapper(text((house as House).capacity.title), () {}),
            wrapper(text((house as House).term.title), () {}),
            wrapper(text((house as House).status.title), () {}),
            wrapper(text((house as House).intro), () {}),
            wrapper(text((house as House).location), () {}),
            wrapper(text((house as House).priceInYuan.toString()), () {}),
            wrapper((house as House).cover, () {})
          ]))
      .toList();

  List<DataRow> get myRows {
    switch (items.first.runtimeType) {
      case User:
        return userRows;
      case SupportRequest:
      case Order:
        return orderRows;
      case House:
        return houseRows;
    }
  }

  DataCell wrapper(Widget child, Function onTap) => DataCell(
      Container(width: frameWidth / (fieldNames.length + 1), child: child),
      onTap: onTap);

  Widget text(String text) =>
      Text(text, softWrap: true, overflow: TextOverflow.ellipsis);
}
