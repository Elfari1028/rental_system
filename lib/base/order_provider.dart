part of 'order.dart';

class OrderProvider extends IOClient {
  static OrderProvider _instance = new OrderProvider();
  static OrderProvider get instance => _instance;

  Future<bool> create(Order order) async {
    if (order.type.isShort)
      order.status =
          order.type.isShort ? OrderStatus.unpaid : OrderStatus.submitted;
    Map response;
    try {
      response = await communicateWith(
        method: "POST",
        actionName: "CREATE ORDER",
        target: 'order/create/',
        param: order.toCreateMap(),
      );
    } on CabinError catch (e) {
      BotToast.showSimpleNotification(title: "下单失败");
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> updateOrder(Order order) async {
    Map response;
    try {
      response = await communicateWith(
        method: "POST",
        actionName: "CREATE ORDER",
        target: 'order/update/',
        param: order.toCommMap(),
      );
    } on CabinError catch (e) {
      BotToast.showSimpleNotification(title: "修改失败");
      return false;
    }
    return true;
  }
  Future<List<Order>> getAllOrders() async {
    Map response;
    try {
      response = await communicateWith(
        method: "GET",
        actionName: "GET ALL ORDER",
        target: 'order/getall/',
      );
    } on CabinError catch (e) {
      BotToast.showSimpleNotification(title: "修改失败");
      return null;
    }
    return getOrdersFromResponse(response);
  }
  static List<Order> getOrdersFromResponse(Map response) {
    List<Order> ret = new List<Order>();
    List<dynamic> orderMaps = response["data"];
    orderMaps.forEach((element) {
      ret.add(Order.fromMap(element as Map));
    });
    return ret;
  }

}
