import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/error.dart';
import 'package:cabin/base/house.dart';
import 'package:cabin/widget/editor/custom_radio.dart';
import 'package:cabin/widget/editor/input_field.dart';
import 'package:cabin/widget/editor/photo_uploader.dart';
import 'package:flutter/material.dart';

class HouseEditor extends StatefulWidget {
  House house;
  HouseEditor(this.house);
  createState() => HouseEditorState();
}

class HouseEditorState extends State<HouseEditor> {
  Map<String, CabinInputFieldController> controllers;
  Map<String, dynamic> values;
  bool isSubmitting = false;
  CabinPhotoGrouperController picController = new CabinPhotoGrouperController();
  House house;
  @override
  void initState() {
    super.initState();
    if (widget.house != null) {
      house = widget.house;
      picController = CabinPhotoGrouperController.fromPaths(house.imagePaths);
    } else
      house = new House.create();
    controllers = {
      "id": CabinInputFieldController(initValue: house.id.toString()),
      "title": CabinInputFieldController(initValue: house.title),
      "location":
          CabinInputFieldController(initValue: house.location.toString()),
      "intro": CabinInputFieldController(initValue: house.intro),
      "price": CabinInputFieldController(initValue: house.price.toString()),
    };
    values = {
      "capacity": house.capacity,
      "term": house.term,
      "status": house.status,
    };
  }

  @override
  Widget build(BuildContext context) {
    picController = CabinPhotoGrouperController.fromPaths(house.imagePaths);
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
              width: 500,
              padding: EdgeInsets.all(30),
              child: ListView(shrinkWrap: true, children: list,physics:ClampingScrollPhysics(),),
            ),
    ));
  }

  List<Widget> get list =>  <Widget>[
        BackButton(),
        idField(),
        titleField(),
        locationField(),
        introField(),
        priceField(),
        termField(),
        statusField(),
        capacityField(),
        pictureField(),
        submitButton(),
      ];

  Widget idField() => CabinInputField(
      title: "ID",
      enabled: false,
      makeErrorText: (value) => null,
      controller: controllers["id"]);
  Widget titleField() => CabinInputField(
      title: "标题",
      makeErrorText: (value) {
        if (value.length > 20)
          return "长度不得超过20";
        else if (value.length == 0)
          return "不得留空";
        else
          return null;
      },
      hintText: "请输入标题",
      controller: controllers["title"]);
  Widget introField() => CabinInputField(
      title: "介绍",
      makeErrorText: (value) {
        if (value.length == 0)
          return "不得留空！";
        else
          return null;
      },
      hintText: "请输入房屋介绍（MarkDown）",
      controller: controllers["intro"]);
  Widget locationField() => CabinInputField(
      title: "地址",
      makeErrorText: (value) {
        if (value.length == 0) {
          return "不得留空";
        } else
          return null;
      },
      hintText: "请输入地址",
      controller: controllers["location"]);

  Widget priceField() => CabinInputField(
      title: "价格（单位：分）",
      makeErrorText: (value) {
        if (value.contains(RegExp(r'[^0-9]'))) {
          return "不得包含字符！";
        } else
          return null;
      },
      hintText: "请输入价格（单位:分）",
      controller: controllers["price"]);
  Widget termField() => CabinRadioField(
      enabled: true,
      labels: ["短租", "长租"],
      values: HouseTerm.values,
      title: "类型",
      onChange: (term) {
        values["term"] = term as HouseTerm;
        return;
      });
  Widget statusField() => CabinRadioField(
      enabled: true,
      labels: [ "正常出租","暂停出租 "],
      values: HouseStatus.values,
      title: "类型",
      onChange: (status) {
        values["status"] = status as HouseStatus;
        return;
      });
  Widget capacityField() => CabinRadioField(
        enabled: true,
        labels: ["单人", "双人", "四人"],
        values: HouseCapacity.values,
        title: "居住人数",
        onChange: (type) {
          values["capacity"] = type as HouseCapacity;
          return;
        },
      );
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
    if (isSubmitting == false) {
      setState(() {});
      return;
    }
    house.price = int.parse(controllers["price"].text);
    house.intro = controllers["intro"].text;
    house.title = controllers["title"].text;
    house.location = controllers["location"].text;
    house.status = values["status"];
    house.term = values["term"];
    house.capacity = values["capacity"];
    House tmp;
    bool result;
    if (house.id == -1)
      tmp = await HouseProvider.instance
          .create(house, picController.getPendedPictures());
    else
      await HouseProvider.instance
          .update(house, picController.getPendedPictures());
    if (result == true) {
      Toaster.showToast(title: "修改成功");
    } else if (tmp != null) {
      house = tmp;
      Toaster.showToast(title: "创建成功");
    }
    isSubmitting = false;
    setState(() {});
    return;
  }
}
