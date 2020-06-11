part of 'support_request.dart';

class SupportRequestProvider extends IOClient {
  static SupportRequestProvider _instance = new SupportRequestProvider();
  static SupportRequestProvider get instance => _instance;

  Future<bool> create(SupportRequest request, List<Picture> pictures) async {
    Map response;
    try {
      int pgid = await PictureGroupProvider.instance.upload(pictures);
      request.pictureGroupID = pgid;
      response = await communicateWith(
        target: "/support/create/",
        method: "POST",
        actionName: "create",
        param: request.toCreateMap(),
      );
    } on CabinError catch (e) {
      BotToast.showSimpleNotification(title: "创建失败", subTitle: e.toString());
      return false;
    }
    return true;
  }
}
