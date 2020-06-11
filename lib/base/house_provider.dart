part of 'house.dart';

class HouseProvider extends IOClient {
  static HouseProvider _instance = new HouseProvider();
  static HouseProvider get instance => _instance;

  Future<bool> suspend(int hid) async {
    try {
      await communicateWith(
          target: '/house/suspend/',
          param: {"hid": hid},
          method: "POST",
          actionName: "Suspend");
    } on CabinError catch (e) {
      BotToast.showSimpleNotification(title: "操作失败", subTitle: e.toString());
      return false;
    }
    return true;
  }

  static List<House> getHouseListFromResponse(Map response) {
    List<House> ret = new List<House>();
    List<dynamic> houseMaps = response["data"];
    houseMaps.forEach((element) {
      ret.add(House.fromMap(element as Map));
    });
    return ret;
  }

  Future<List<House>> getRecommendations(int count) async {
    Map response = await communicateWith(
      target: "house/recommend/",
      param: {"count": count},
      method: "POST",
      actionName: "Get REC",
    );
    return getHouseListFromResponse(response);
  }

  Future<List<House>> getAllHouses() async {
    Map response = await communicateWith(
      target: "house/getall/",
      method: "GET",
      actionName: "Get ALL",
    );
    return getHouseListFromResponse(response);
  }

  Future<List<House>> search(String keyword) async {
    Map response = await communicateWith(
      target: "house/search/",
      method: "POST",
      param: {"keyword": keyword},
      actionName: "Get ALL",
    );
    return getHouseListFromResponse(response);
  }

  Future create(House house, List<Picture> pictures) async {
    Map response;
    try {
      int pgid;
      pgid = await PictureGroupProvider.instance.upload(pictures);
      house.pictureGroupID = pgid;
      response = await communicateWith(
        target: "house/create/",
        method: "POST",
        actionName: "create",
        param: house.toMap(),
      );
    } on CabinError catch (e) {
      BotToast.showSimpleNotification(title: "创建失败", subTitle: e.toString());
    }
    return House.fromMap(response["data"]);
  }

  Future update(House house, List<Picture> appends) async {
    try {
      await communicateWith(
        target: "house/update/",
        method: "POST",
        actionName: "create",
        param: house.toMap(),
      );
    } on CabinError catch (e) {
      BotToast.showSimpleNotification(title: "创建失败", subTitle: e.toString());
    }
  }

  static List<House> getDemoRecomSync() {
    // await Future.delayed(Duration(seconds: 1));
    return <House>[
      House(
          id: 1,
          title: "精品电梯公寓房——近地铁、商圈",
          status: HouseStatus.normal,
          term: HouseTerm.short,
          capacity: HouseCapacity.bi,
          location: "",
          price: 20000,
          pictureGroupID: 1,
          imagePaths: [
            "https://cdn.pixabay.com/photo/2014/08/11/21/39/wall-416060_1280.jpg",
            "https://cdn.pixabay.com/photo/2016/11/18/17/20/couch-1835923_1280.jpg",
            "https://cdn.pixabay.com/photo/2015/04/20/13/38/furniture-731449_1280.jpg",
          ],
          intro: "### This is it \n ----- \n Nice!"),
      House(
          id: 2,
          title: "SlowTown | 音乐学院 | 共享居住空间",
          status: HouseStatus.normal,
          term: HouseTerm.long,
          capacity: HouseCapacity.quad,
          location: "",
          price: 22000,
          pictureGroupID: 1,
          imagePaths: [
            "http://5b0988e595225.cdn.sohucs.com/images/20190927/00728791e8b34b529c68715728d2325a.jpeg"
          ],
          intro: "### This is it \n ----- \n Nice!"),
      House(
        id: 3,
        title: "青年商务单间",
        status: HouseStatus.normal,
        term: HouseTerm.short,
        capacity: HouseCapacity.mono,
        location: "",
        price: 32000,
        pictureGroupID: 1,
        imagePaths: ["https://i01piccdn.sogoucdn.com/8b533124cb0e7712"],
        intro: "### This is it \n ----- Nice!",
      ),
    ];
  }

  static Future<List<House>> getDemoRecom() async {
    // await Future.delayed(Duration(seconds: 1));
    return getDemoRecomSync();
  }
}
