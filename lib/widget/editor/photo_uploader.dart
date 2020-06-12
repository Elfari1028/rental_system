import 'package:cabin/base/picture.dart';
import 'package:flutter/material.dart';

class CabinPhotoGrouperController {
  List<Picture> pics = new List<Picture>();
  CabinPhotoGrouperController();
  CabinPhotoGrouperController.fromPaths(List<String> paths) {
    paths.forEach((element) {
      pics.add(Picture.fromLink(element));
    });
    pics = pics.sublist(0, pics.length < 9 ? pics.length : 9);
  }
  List<Picture> getPendedPictures() {
    List<Picture> ret = new List<Picture>();
    pics.forEach((element) {
      if (element.isFromLink == false) ret.add(element);
    });
    return ret;
  }
}

class CabinPhotoGrouper extends StatefulWidget {
  CabinPhotoGrouperController controller;
  bool canAdd;
  CabinPhotoGrouper(this.controller, {this.canAdd = true});
  createState() => CabinPhotoGrouperState();
}

class CabinPhotoGrouperState extends State<CabinPhotoGrouper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 950,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        GridView(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1),
          children: getChildern(),
          physics: NeverScrollableScrollPhysics(),
        )
      ]),
    );
  }

  List<Widget> getChildern() {
    List<Widget> ret = new List();
    widget.controller.pics.forEach((element) {
      ret.add(Padding(padding: EdgeInsets.all(10), child: element.image));
    });
    if (widget.canAdd) if (ret.length < 9) {
      ret.add(Card(
          child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                Picture newPic = await PictureGroupProvider.pickFile();
                if (newPic == null) return;
                widget.controller.pics.add(newPic);
                setState(() {});
              })));
    }
    return ret;
  }
}
