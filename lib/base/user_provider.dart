part of 'user.dart';

class UserProvider extends IOClient {
  static User _user;
  static User get currentUser => _user;
  static bool get loginStatus => (_user != null);
  static UserProvider _instance = UserProvider();

  static UserProvider get instance => _instance;

  Future<bool> tryGetMyInfo() async {
    Map response;
    bool result = true;
    try {
      response = await communicateWith(
          target: "/account/get/", actionName: "Get My Info", method: "GET");
    } on BackError catch (e) {
      if (e.code == "ACCOUNT_NOT_LOGGEDIN") {
        result = false;
      } else
        throw e;
    }
    if (!result) {
      _user = null;
      return false;
    }
    if (!response.containsKey("data"))
      throw FrontError("UserProvider", "NULL_PARAM");
    if (!(response["data"] is Map))
      throw FrontError("UserProvider", "ERR_ARAM_TYPE");
    result = true;
    _user = User.fromMap(response["data"]);
    return true;
  }

  Future login(String id, String password) async {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["id"] = id;
    map["password"] = password;
    Map response = await communicateWith(
        param: map,
        target: "/account/login/",
        actionName: "Login",
        method: "POST");

    if (!response.containsKey("data"))
      throw FrontError("LoginInfoProvider", "NULL_PARAM");
    if (!(response["data"] is Map))
      throw FrontError("LoginInfoProvider", "ERR,ARAM_TYPE");
    _user = User.fromMap(response["data"]);
  }

  Future<dynamic> register(User user) async {
    Map response = await communicateWith(
        param: user.toMap(),
        target: "/account/register/",
        actionName: "register",
        method: "POST");
  }

  Future<List<User>> getAllUsers() async {
    Map response;
    try{
     response = await communicateWith(
        method: "GET", actionName: "Get All Users", target: "/account/getall/");
    }on FrontError catch(e){
      BotToast.showSimpleNotification(title: "失败",subTitle: e.msg);
      print(e.msg);
      return null;
    } 
    List usersMap = response["data"];
    List<User> ret = new List<User>();
    usersMap.forEach((element) {
      ret.add(User.fromMap(element as Map));
    });
    return ret;
  }

  Future<bool> update(User user) async {
    try {
      await communicateWith(
          method: "POST",
          actionName: "UPDATE USER",
          param: user.toMap(),
          target: '/account/update/');
    } on CabinError catch (e) {
      BotToast.showSimpleNotification(title: "更新失败", subTitle: e.msg);
      return false;
    }
    return true;
  }
}
