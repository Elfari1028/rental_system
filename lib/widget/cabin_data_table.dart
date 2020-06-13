import 'dart:js_util';

import 'package:cabin/base/cabin_model.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/ioclient.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/support_request.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/display_util.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

class CabinDataTable extends StatefulWidget {
  final List<CabinModel> items;
  final UserType userType;
  VoidCallback refresh;
  CabinDataTable(
      {@required this.items, @required this.userType, @required this.refresh});
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
    var payButton = RaisedButton(
        onPressed: () {
          makePayment();
        },
        child: Text("付款"));
    var printButton = RaisedButton(
        onPressed: () {
          IOClient.openContract();
        },
        child: Text("打印合同"));
    var cancelButton = RaisedButton(
        onPressed: () async {
          OrderStatus newstatus = await showDialog<OrderStatus>(
              context: context,
              builder: (ctx) {
                return SimpleDialog(title: Text("更改状态"), children: [
                  SimpleDialogOption(child: Text("取消订单"), onPressed: (){
                    Navigator.of(context).pop(OrderStatus.canceled);
                  },), SimpleDialogOption(child: Text("返回"), onPressed: (){
                    Navigator.of(context).pop(null);
                  },)
                ]);
              });
          if (newstatus == null) return;
          order.status = newstatus;
          OrderProvider.instance.updateOrder(order);
          setState(() {});
          widget.refresh();
        },
        color: Colors.red,
        child: Text("取消订单"));
    var reportButton = RaisedButton(
        child: Text("投诉"),
        onPressed: () async {
          await Navigator.of(context).pushNamed('/support/create',
              arguments: {'order': order, 'init': RequestType.report});
          setState(() {});
          widget.refresh();
        });
    var fixButton = RaisedButton(
        child: Text("报修"),
        onPressed: () async {
          await Navigator.of(context).pushNamed('/support/create',
              arguments: {'order': order, 'init': RequestType.maintenance});
          setState(() {});
          widget.refresh();
        });
    switch (order.status) {
      case OrderStatus.submitted:
        ret.add(cancelButton);
        break;
      case OrderStatus.unpaid:
        if (order.type.isShort)
          ret.add(payButton);
        else
          ret.add(printButton);
        ret.add(cancelButton);
        break;
      case OrderStatus.pendingReview:
        ret.add(cancelButton);
        break;
      case OrderStatus.rejected:
        break;
      case OrderStatus.canceled:
        break;
      case OrderStatus.effective:
        ret.add(fixButton);
        ret.add(reportButton);
        if (!order.type.isShort &&
            order.endTime.difference(DateTime.now()).inDays <= 7)
          ret.add(RaisedButton(
              onPressed: () {
                makePayment();
              },
              child: Text("续费")));
        break;
      case OrderStatus.over:
        ret.add(reportButton);
        break;
    }
    return Column(children: ret);
  }

  @override
  Widget requestActions(SupportRequest request) {
    List<Widget> ret = new List<Widget>();
    var replyButton = RaisedButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/support/conversation',
              arguments: {"request": request});
          setState(() {});
          widget.refresh();
        },
        color: Colors.green,
        child: Text("回复"));
    var closeButton = RaisedButton(
        onPressed: () async {
          await SupportRequestProvider.instance.close(request);
          setState(() {});
          widget.refresh();
        },
        color: Colors.green,
        child: Text("关闭"));
    var detailButton = RaisedButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/support/conversation',
              arguments: {"request": request});
          setState(() {});
          widget.refresh();
        },
        color: Colors.green,
        child: Text("详情"));
    var rateButton = RaisedButton(
        onPressed: () {
          rate(request);
        },
        color: Colors.green,
        child: Text("评分"));
    switch (request.status) {
      case RequestStatus.pending:
        ret.add(replyButton);
        ret.add(closeButton);
        break;
      case RequestStatus.ongoing:
        ret.add(replyButton);
        ret.add(closeButton);
        break;
      case RequestStatus.dispatched:
        ret.add(replyButton);
        ret.add(closeButton);
        break;
      case RequestStatus.closed:
        ret.add(rateButton);
        ret.add(detailButton);
        break;
      case RequestStatus.rated:
        ret.add(detailButton);
        break;
    }
    return Column(
      children: ret,
    );
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
    var replyButton = RaisedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/support/conversation',
              arguments: {"request": request});
        },
        color: Colors.green,
        child: Text("回复"));
    var detailButton = RaisedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/support/conversation',
              arguments: {"request": request});
        },
        color: Colors.green,
        child: Text("详情"));
    switch (request.status) {
      case RequestStatus.pending:
        break;
      case RequestStatus.ongoing:
        break;
      case RequestStatus.dispatched:
        ret.add(replyButton);
        break;
      case RequestStatus.closed:
        ret.add(detailButton);
        break;
      case RequestStatus.rated:
        ret.add(detailButton);
        break;
    }
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
          setState(() {});
          widget.refresh();
        },
        child: Text("修改")));
    return Column(children: ret);
  }

  @override
  Widget orderActions(Order order) {
    List<Widget> ret = new List<Widget>();
    var statusButton = RaisedButton(
      onPressed: () async {
        OrderStatus newstatus = await showDialog<OrderStatus>(
            context: context,
            builder: (ctx) {
              List<SimpleDialogOption> options = new List<SimpleDialogOption>();
              OrderStatus.values.forEach((element) {
                options.add(SimpleDialogOption(
                  child: Text(element.title),
                  onPressed: () {
                    Navigator.of(context).pop(element);
                  },
                ));
              });
              return SimpleDialog(title: Text("更改状态"), children: options);
            });
        if (newstatus == null) return;
        order.status = newstatus;
        OrderProvider.instance.updateOrder(order);
        setState(() {});
        widget.refresh();
      },
      child: Text("更改状态"),
    );
    var printButton = RaisedButton(
        onPressed: () {
          IOClient.openContract();
        },
        child: Text("打印合同"));
    ret.add(statusButton);
    ret.add(printButton);
    return Column(children: ret);
  }

  @override
  Widget requestActions(SupportRequest request) {
    List<Widget> ret = new List<Widget>();
    var replyButton = RaisedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/support/conversation',
              arguments: {"request": request});
        },
        child: Text("回复"));
    var closeButton = RaisedButton(
        onPressed: () async {
          await SupportRequestProvider.instance.close(request);
          setState(() {});
          widget.refresh();
        },
        color: Colors.red,
        child: Text("关闭"));
    var appointButton = RaisedButton(
        onPressed: () {
          appoint(request);
          setState(() {});
          widget.refresh();
        },
        child: Text("指派师傅"));
    var pickupButton = RaisedButton(
      onPressed: () async {
        await SupportRequestProvider.instance
            .appointRespondant(UserProvider.currentUser.id, request.id);
        request.status = RequestStatus.ongoing;
        request.respondant = UserProvider.currentUser;
        setState(() {});
        widget.refresh();
      },
      child: Text("处理"),
    );
    var detailButton = RaisedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/support/conversation',
              arguments: {"request": request});
        },
        child: Text("详情"));
    switch (request.status) {
      case RequestStatus.pending:
        ret.add(replyButton);
        ret.add(closeButton);
        ret.add(pickupButton);
        break;
      case RequestStatus.ongoing:
        ret.add(replyButton);
        ret.add(closeButton);
        ret.add(appointButton);
        break;
      case RequestStatus.dispatched:
        ret.add(replyButton);
        ret.add(closeButton);
        break;
      case RequestStatus.closed:
        ret.add(detailButton);
        break;
      case RequestStatus.rated:
        ret.add(detailButton);
        break;
    }
    return Column(
      children: ret,
    );
  }

  @override
  Widget userActions(User user) {
    List<Widget> ret = new List<Widget>();
    ret.add(RaisedButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/account/edit',
              arguments: {'user': user, 'isAdmin': true});
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
  double itemWidth;
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
    itemWidth = frameWidth / (fieldNames.length + 1);
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: body());
  }

  Widget body() {
    return DataTable(
      dataRowHeight: 250,
      columns: myColumns,
      rows: myRows,
      columnSpacing: 15,
      showCheckboxColumn: false,
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
            wrapper(text((user as User).id.toString()), null),
            wrapper((user as User).avatarImage, null),
            wrapper(text((user as User).name), null),
            wrapper(text((user as User).phone), null),
            wrapper(text((user as User).email), null),
            wrapper(text("********"), null),
            wrapper(text((user as User).sex.name), null),
            wrapper(text((user as User).type.name), null),
            wrapper(text((user as User).age.toString()), null),
            wrapper(text((user as User).intro), null),
          ]))
      .toList();

  List<DataRow> get orderRows => items
      .map((order) => DataRow(cells: [
            wrapper(orderActions(order as Order), null),
            wrapper(text((order as Order).id.toString()), null),
            wrapper(text((order as Order).status.title), null),
            wrapper(text((order as Order).type.title), null),
            wrapper(text((order as Order).priceInYuan.toString() + "元"), null),
            wrapper(text((order as Order).createTime.toMyString()), null),
            wrapper(text((order as Order).startTime.toMyString()), null),
            wrapper(text((order as Order).endTime.toMyString()), null),
            wrapper(
                CabinDisplayUtil.miniHouseCard((order as Order).house), null),
            wrapper(
                CabinDisplayUtil.miniUserCard((order as Order).rentee), null),
            wrapper(CabinDisplayUtil.miniUserCard((order as Order).respondant),
                null),
          ]))
      .toList();
  List<DataRow> get requestRows => items
      .map((request) => DataRow(cells: [
            wrapper(requestActions(request as SupportRequest), null),
            wrapper(text((request as SupportRequest).id.toString()), null),
            wrapper(text((request as SupportRequest).status.title), null),
            wrapper(text((request as SupportRequest).type.title), null),
            wrapper(text((request as SupportRequest).content), null),
            wrapper(text((request as SupportRequest).createTime.toMyString()),
                null),
            wrapper((request as SupportRequest).cover, null),
            wrapper(
                CabinDisplayUtil.miniOrderCard(
                    (request as SupportRequest).order),
                null),
            wrapper(
                CabinDisplayUtil.miniHouseCard(
                    (request as SupportRequest).order.house),
                null),
            wrapper(
                CabinDisplayUtil.miniUserCard(
                    (request as SupportRequest).rentee),
                null),
            wrapper(
                CabinDisplayUtil.miniUserCard(
                    (request as SupportRequest).maintenance),
                null),
            wrapper(
                CabinDisplayUtil.miniUserCard(
                    (request as SupportRequest).respondant),
                null),
          ]))
      .toList();
  List<DataRow> get houseRows => items
      .map((house) => DataRow(cells: [
            wrapper(houseActions(house as House), null),
            wrapper(text((house as House).id.toString()), null),
            wrapper(text((house as House).title), null),
            wrapper(text((house as House).capacity.title), null),
            wrapper(text((house as House).term.title), null),
            wrapper(text((house as House).status.title), null),
            wrapper(text((house as House).intro), null),
            wrapper(text((house as House).location), null),
            wrapper(text((house as House).priceInYuan.toString()), null),
            wrapper((house as House).cover, null)
          ]))
      .toList();

  List<DataRow> get myRows {
    switch (items.first.runtimeType) {
      case User:
        return userRows;
      case SupportRequest:
        return requestRows;
      case Order:
        return orderRows;
      case House:
        return houseRows;
    }
  }

  DataCell wrapper(Widget child, Function onTap) => DataCell(
      Container(width: frameWidth / (fieldNames.length + 1), child: child),
      onTap: onTap);

  Widget text(String text) => Wrap(children: [Text(text)]);

  void makePayment() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("如何付款?"),
              content: Text("请通过邮箱、电话和现场付款等方式联系客服进行付款。等待客服确认后订单才会生效。"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("我知道了"))
              ],
            ));
    setState(() {});
    widget.refresh();
  }

  void rate(SupportRequest request) async {
    Ratings result = await showDialog<Ratings>(
        context: context,
        builder: (context) {
          double rating = 5;
          String str = "";
          return AlertDialog(
            title: Text("服务评分"),
            content: Column(children: [
              SmoothStarRating(
                  starCount: 5,
                  rating: rating,
                  isReadOnly: false,
                  allowHalfRating: false),
              TextField(
                  onChanged: (value) {
                    str = value;
                  },
                  decoration: InputDecoration(hintText: "在这里输入评价"))
            ]),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(Ratings.fromMap({
                      'srid': request.id,
                      'stars': rating.round(),
                      'content': str
                    }));
                  },
                  child: Text("OK"))
            ],
          );
        });
    if (result != null) {
      await SupportRequestProvider.instance.rate(result);
      setState(() {});
      widget.refresh();
    }
  }

  void appoint(SupportRequest request) async {
    await showDialog<Ratings>(
        context: context,
        builder: (context) {
          String str = "";
          return AlertDialog(
            title: Text("指派师傅"),
            content: TextField(
                onChanged: (value) {
                  str = value;
                },
                decoration: InputDecoration(hintText: "输入维修工人ID")),
            actions: [
              FlatButton(
                  onPressed: () async {
                    if (str != "") {
                      User user = await SupportRequestProvider.instance
                          .appointFixer(int.parse(str), request);
                      Navigator.of(context).pop();
                      if (user == null) return;
                      request.status = RequestStatus.ongoing;
                      request.maintenance = user;
                    }
                  },
                  child: Text("OK"))
            ],
          );
        });
    setState(() {});
    widget.refresh();
  }
}
