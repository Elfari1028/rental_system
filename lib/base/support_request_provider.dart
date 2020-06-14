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
      Toaster.showToast(title: "创建失败", subTitle: e.toString());
      return false;
    }
    return true;
  }

  Future<List<SupportRequest>> getall() async {
    Map response;
    try {
      response = await communicateWith(
        target: "/support/all/",
        method: "GET",
        actionName: "getall",
      );
    } on CabinError catch (e) {
      Toaster.showToast(title: "获取失败", subTitle: e.toString());
      return null;
    }
    return getRequestsFromResponse(response);
  }

  static List<SupportRequest> getRequestsFromResponse(Map response) {
    List requests = response['data'];
    List<SupportRequest> ret = new List<SupportRequest>();
    requests.forEach((element) {
      ret.add(SupportRequest.fromMap(element as Map));
    });
    return ret;
  }

  static List<SupportRequestReply> getConvoFromResponse(Map response) {
    List requests = response['data'];
    List<SupportRequestReply> ret = new List<SupportRequestReply>();
    requests.forEach((element) {
      ret.add(SupportRequestReply.fromMap(element as Map));
    });
    return ret;
  }

  Future<List<SupportRequestReply>> getConversationFor(SupportRequest request) async {
    Map response;
    try {
      response = await communicateWith(
        target: "/support/conversation/",
        method: "POST",
        param: {"id":request.id},
        actionName: "getall",
      );
    } on CabinError catch (e) {
      Toaster.showToast(title: "获取失败", subTitle: e.toString());
      return null;
    }
    return getConvoFromResponse(response);
  }
  Future<SupportRequestReply> replyTo(SupportRequest request,SupportRequestReply reply,List<Picture> pictures) async {
    Map response;
    try {
      int pgid = -1;
      if(pictures != null && pictures.length != 0)
        pgid = await PictureGroupProvider.instance.upload(pictures);
      debugPrint("pgid:"+pgid.toString());
      reply.pictureGroupID = pgid;
      response = await communicateWith(
        target: "/support/reply/",
        method: "POST",
        param: reply.toCreateMap(),
        actionName: "reply to",
      );
    } on CabinError catch (e) {
      Toaster.showToast(title: "回复失败", subTitle: e.toString());
      return null;
    }
    return SupportRequestReply.fromMap(response['data']);
  }

  Future rate(Ratings ratings)async{
    try{
      await communicateWith(
        actionName: "Rate",
        method: "POST",
        param: ratings.toMap(),
        target: '/support/rate/'
      );
    }on CabinError catch(e){
      Toaster.showToast(title: "评价失败", subTitle: e.toString());
      return false;
    }
    return true;
  }

  Future<User> appointFixer(int id,SupportRequest request)async{
    Map response;
    try{
      response = await communicateWith(
        actionName: 'appointFixer',
        method: 'POST',
        param: {'fid':id,'srid':request.id},
        target: '/support/dispatch/'
      );
    }on CabinError catch(e){
      Toaster.showToast(title: "分配失败", subTitle: e.toString());
    }
    return User.fromMap(response['data']);
  }
  Future appointRespondant(int id,int srid)async{
    try{
      await communicateWith(
        actionName: 'appoint',
        method: 'POST',
        param: {'fid':id,'srid':srid},
        target: '/support/pickup/'
      );
    }on CabinError catch(e){
      Toaster.showToast(title: "分配失败", subTitle: e.toString());
    }
  }
  Future close(SupportRequest request)async{
    try{
      await communicateWith(
        actionName: 'close',
        method: 'POST',
        param: {'srid':request.id},
        target: '/support/close/'
      );
    }on CabinError catch(e){
      Toaster.showToast(title: "分配失败", subTitle: e.toString());
      return ;
    }
    request.status = RequestStatus.closed;
  }
}
