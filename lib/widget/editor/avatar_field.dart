import 'package:cabin/base/picture.dart';
import 'package:cabin/base/user.dart';
import 'package:flutter/material.dart';

class CabinAvatarField extends StatefulWidget {
  User user;
  VoidCallback onChanged;
  CabinAvatarField({@required this.user,this.onChanged});
  createState() => CabinAvatarFieldState();
}

class CabinAvatarFieldState extends State<CabinAvatarField> {
  
  bool uploading = false;
  Picture newAvatar;
  User user;
  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        height: 150,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: FlatButton(
                onPressed: uploading?null:onPick,
                child: avatar)));
  }

  Widget get avatar => uploading?Container(height: 50,width: 50,child: CircularProgressIndicator(),):user.avatarImage;

  Future onPick()async{
    newAvatar = await PictureGroupProvider.pickFile();
    if(newAvatar == null)return;
    else uploading = true;
    setState(() {});
    String newUrl = await PictureGroupProvider.instance.uploadAvatar(user.id,newAvatar);
    if(newUrl != null)
      user.newAvatar = newUrl;
    uploading = false;
    setState(() {});
  }
}
