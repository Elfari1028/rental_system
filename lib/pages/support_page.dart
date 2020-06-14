import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/support_request.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:cabin/widget/editor/photo_uploader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SupportConvoPage extends StatefulWidget {
  SupportRequest request;
  SupportConvoPage(this.request);
  createState() => SupportConvoPageState();
}

class SupportConvoPageState extends State<SupportConvoPage> {
  bool convoReady = false;
  TextEditingController replyController = new TextEditingController();
  CabinPhotoGrouperController picController = new CabinPhotoGrouperController();
  List<SupportRequestReply> replies;

  @override
  void initState() {
    super.initState();
    refreshConvo();
  }

  @override
  Widget build(BuildContext context) {
    return CabinScaffold(
      navBar: CabinNavBar(),
      body: requestDetail(),
      side: Column(children: [
        conversation(),
        if (widget.request.status.value < 4) replyField()
      ]),
      bodyRatio: 5,
    );
  }

  Future refreshConvo() async {
    replies = await SupportRequestProvider.instance
        .getConversationFor(widget.request);
    if (replies != null) {
      convoReady = true;
      replies.sort();
    }

    setState(() {});
  }

  Widget requestDetail() => Container(
      width: 400,
      child: Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackButton(),
                          Text("工单详情"),
                          Container(
                            width: 50,
                          )
                        ]),
                    CarouselSlider(
                        items: imageCards(),
                        options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          initialPage: 0,
                          viewportFraction: 0.8,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                        )),
                    Text(
                      widget.request.content,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    Divider(thickness: 1),
                    ListTile(
                        title: Text("创建时间"),
                        subtitle: Text(widget.request.createTime.toMyString())),
                    Divider(thickness: 1),
                    ListTile(
                        title: Text("状态"),
                        subtitle: Text(widget.request.status.title)),
                    Divider(thickness: 1),
                    ListTile(
                        title: Text("类型"),
                        subtitle: Text(widget.request.type.title)),
                    Divider(thickness: 1),
                    ListTile(
                        title: Text("订单编号"),
                        subtitle: Text(widget.request.order.id.toString())),
                    Divider(thickness: 1),
                    if (widget.request.status != RequestStatus.closed &&
                        widget.request.status != RequestStatus.rated)
                      RaisedButton(
                          onPressed: () async {
                            await SupportRequestProvider.instance
                                .close(widget.request);
                            setState(() {});
                            refreshConvo();
                          },
                          child: Text("关闭工单")),
                    if (widget.request.status == RequestStatus.closed &&
                        UserProvider.currentUser.type == UserType.rentee)
                      RaisedButton(
                          onPressed: () async {
                             await showDialog<bool>(
        context: context,
        builder: (context) {
          double rating = 5;
          String str = "";
          return SimpleDialog(title: Text("服务评分"), children: [
            SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    SmoothStarRating(
                        starCount: 5,
                        rating: rating,
                        isReadOnly: false,
                        allowHalfRating: false),
                    TextField(
                        onChanged: (value) {
                          str = value;
                        },
                        decoration: InputDecoration(hintText: "在这里输入评价")),
                    RaisedButton(
                        onPressed: () async {
                          bool result = await SupportRequestProvider.instance.rate(
                              Ratings.fromMap({
                            'srid': widget.request.id,
                            'stars': rating.round(),
                            'content': str
                          }));
                          if(result == true)widget.request.status = RequestStatus.rated;
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                ))
          ]);
        });
                            refreshConvo();
                          },
                          child: Text("评分")),
                  ]))));

  Widget replyField() {
    List<Widget> childrens = new List<Widget>();
    childrens.add(TextField(
      maxLines: null,
      controller: replyController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "回复内容",
        errorText: replyController.text == "" ? "不得留空" : null,
      ),
      onChanged: (value) {
        setState(() {});
      },
    ));
    childrens.add(CabinPhotoGrouper(
      picController,
      canAdd: true,
    ));
    childrens.add(RaisedButton(onPressed: onSubmit, child: Text('回复')));
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Container(
        width: 600,
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: childrens),
      ),
    );
  }

  Widget conversation() {
    if (!convoReady)
      return Container(
          width: 600,
          alignment: Alignment.center,
          child: Container(
              height: 50, width: 50, child: CircularProgressIndicator()));
    List<Widget> childrens = new List<Widget>();
    childrens.add(Text(
      "消息",
      style: TextStyle(fontSize: 25),
    ));
    childrens.add(Divider(
      thickness: 3,
    ));
    childrens.addAll(messages());
    return Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: Container(
            width: 600,
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: childrens)));
  }

  Future onSubmit() async {
    var dialog = ProgressDialog(context, isDismissible: false);
    await dialog.show();
    if (replyController.text == "") {
      dialog.hide();
      Toaster.showToast(title: "回复不得留空");
      return;
    }
    SupportRequestReply reply = SupportRequestReply.create(
        widget.request.id, UserProvider.currentUser, replyController.text);
    SupportRequestReply result = await SupportRequestProvider.instance
        .replyTo(widget.request, reply, picController.getPendedPictures());
    if (result != null) {
      picController = CabinPhotoGrouperController();
      replyController.text = "";
    }
    await refreshConvo();
    await dialog.hide();
    setState(() {});
  }

  List<Widget> messages() {
    List<Widget> ret = List();
    ret.add(bubble(widget.request.rentee, widget.request.content,
        widget.request.createTime));
    replies.forEach((element) {
      if (element.pictureGroupID != -1)
        ret.add(bubble(element.user, element.content, element.time,
            paths: element.imagePaths));
      else
        ret.add(bubble(element.user, element.content, element.time));
    });
    return ret;
  }

  Widget bubble(User user, String content, DateTime time,
      {List<String> paths}) {
    if (paths != null) debugPrint(paths.toString());
    return Container(
        width: 600,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: user.avatarImage))),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (user.id != UserProvider.currentUser.id)
                Text(user.type.name + " ID: " + user.id.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold))
              else
                Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(time.toMyString())
            ])
          ]),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(content),
          ),
          if (paths != null)
            CabinPhotoGrouper(
              CabinPhotoGrouperController.fromPaths(paths),
              canAdd: false,
            ),
          Divider(
            thickness: 1,
          ),
        ]));
  }

  List<Widget> imageCards() {
    List<Widget> ret = List<Widget>();
    for (int i = 0; i < widget.request.imagePaths.length; i++) {
      ret.add(Container(
        // height: 600,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: RaisedButton(
              onPressed: () {},
              color: Colors.transparent,
              hoverColor: Colors.white10,
              highlightColor: Colors.black12,
              elevation: 7.0,
              hoverElevation: 10.0,
              padding: EdgeInsets.zero,
              child: widget.request.images[i],
            )),
      ));
    }
    return ret;
  }
}
