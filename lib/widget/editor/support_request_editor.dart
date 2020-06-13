import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/base/order.dart';
import 'package:cabin/base/support_request.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/widget/editor/custom_radio.dart';
import 'package:cabin/widget/editor/input_field.dart';
import 'package:cabin/widget/editor/photo_uploader.dart';
import 'package:flutter/material.dart';

class SupportRequestEditor extends StatefulWidget {
  Order order;
  RequestType initalType;
  SupportRequestEditor(this.order, this.initalType);
  createState() => SupportRequestEditorState();
}

class SupportRequestEditorState extends State<SupportRequestEditor> {
  Map<String, CabinInputFieldController> controllers;
  Map<String, dynamic> values;
  bool isSubmitting = false;
  CabinPhotoGrouperController picController = new CabinPhotoGrouperController();
  @override
  void initState() {
    super.initState();
    controllers = {
      "content": CabinInputFieldController(initValue:"内容："),
    };
    values = {"type":widget.initalType};
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      elevation: 50,
      child: isSubmitting
          ? SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            )
          : Container(
              width: 1300,
              padding: EdgeInsets.all(30),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  BackButton(),
                  orderCard(),
                  houseCard(),
                  editField(),
                ],
              )),
            ),
    ));
  }

  Widget orderCard() => Card(
          elevation: 7,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(10),
          child: Container(
      width: 400,
      padding: EdgeInsets.all(15),
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("订单信息",
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Text("订单ID: " + widget.order.id.toString(),
                    overflow: TextOverflow.ellipsis),
                Text("下单时间: " + widget.order.createTime.toMyString(),
                    overflow: TextOverflow.ellipsis),
                Text("订单状态：" + widget.order.status.title,
                    overflow: TextOverflow.ellipsis),
              ])));

  Widget houseCard() => Card(
          elevation: 7,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(10),
          child:Container(
      width: 400,
      padding: EdgeInsets.all(15),
      child:  Column(  crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,children: [
              Text("房屋信息",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      ),
            ),
            Text("房屋ID: " + widget.order.house.id.toString(),
                overflow: TextOverflow.ellipsis),
            Text("房屋地址: " + widget.order.house.location,
                overflow: TextOverflow.ellipsis),
            Text("房屋状态：" + widget.order.house.status.title,
                overflow: TextOverflow.ellipsis),
          ])));

  Widget editField() => Card(
          elevation: 7,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(10),
          child: Container(
      width: 400,
      padding: EdgeInsets.all(0),
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CabinRadioField(
                    enabled: true,
                    title: "类型",
                    labels: ['报修', '投诉'],
                    values: RequestType.values,
                    onChange: (value){
                      values['type'] = value as RequestType;
                      return ;
                    }),
                CabinInputField(
                  title: "描述",
                  hintText: "在这里描述你遇到的问题。",
                  makeErrorText: (value) {
                    if (value.length == 0)
                      return "不得留空!";
                    else
                      return null;
                  },
                  maxLines: null,
                  controller: controllers['content'],
                ),
                Text("上传图片(至少一张):"),
                pictureField(),
                submitButton(),
              ])));
  Widget pictureField() => CabinPhotoGrouper(picController);

  Widget submitButton() {
    return RaisedButton(
      onPressed: (){ onSubmit();},
      child: Text("提交修改"),
    );
  }


  Future onSubmit() async {
    isSubmitting = true;
    setState(() {});

    controllers.forEach((key, controller) {
      if (controller.hasError) {
        isSubmitting = false;
        return;
      }
    });
    if (isSubmitting == false ||
        picController.getPendedPictures().length == 0) {
      Toaster.showToast(title: "图片不得为空");
      setState(() {});
      return;
    }
    SupportRequest newRequest = SupportRequest.create(UserProvider.currentUser,
        widget.order, controllers['content'].text, values['type']);
    bool result = await SupportRequestProvider.instance
        .create(newRequest, picController.getPendedPictures());
    if (result == true) {
      Toaster.showToast(title: "创建成功");
      Navigator.of(context).pop();
    }
    isSubmitting = false;
    setState(() {});
    return;
  }
}
