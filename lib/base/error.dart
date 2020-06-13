import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class CabinError {
  String className;
  String code;
  String msg;
  CabinError([this.className = "null", this.code = "null", this.msg = "null"]);
  String toString() {
    String ret = "";
    //this.runtimeType.toString();
    if (this.className.length > 0) ret += ":" + this.className;
    if (this.code.length > 0) ret += ":" + this.code;
    if (this.msg.length > 0) ret += ":" + this.msg;
    return ret;
  }
}

class FrontError extends CabinError {
  FrontError([className = "", code = "", msg = ""])
      : super(className, code, msg);
}

class BackError extends CabinError {
  BackError([className = "", code = "", msg = ""])
      : super(className, code, msg);
}

class Toaster{
    static showToast({Widget leading,String title,String subTitle}){
    leading??=Icon(
          Icons.notifications_active,
          color: Colors.brown,
        );
     BotToast.showCustomNotification(
       toastBuilder:(ctx)=>  Card(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical:5),
        elevation: 7.0,
        child: ListTile(
          leading: leading,
          title: Text(title,  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          subtitle: subTitle==null?null:Text(subTitle, style:TextStyle(fontSize: 15, color: Colors.grey[700]))),
        ),
       );
  }
  static showSimpleToast({Widget leading,String title,String subTitle}){
    leading??=Icon(
          Icons.notifications_active,
          color: Colors.brown,
        );
     BotToast.showNotification(
        leading: (func) => leading,
        title: (func) => Text(
          title,
          style: TextStyle(fontSize: 25),
        ),
        subtitle: subTitle == null?null:(func) => Text(
          subTitle,
          style: TextStyle(fontSize: 15, color: Colors.grey)));
  }
}