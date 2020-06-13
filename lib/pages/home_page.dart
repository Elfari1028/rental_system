import 'package:cabin/base/house.dart';
import 'package:cabin/base/tasker.dart';
import 'package:cabin/widget/cabin_nav_bar.dart';
import 'package:cabin/widget/cabin_scaffold.dart';
import 'package:cabin/widget/house_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double _screenWidth;
  double _screenHeight;
  TextEditingController keywords = TextEditingController();
  _Tasker tasker;

  @override
  void initState() {
    super.initState();
    tasker = _Tasker(() {
      if (!mounted) return;
      setState(() {
      });
    });
    tasker.start();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    // tasker.start();
    return CabinScaffold(
        navBar: CabinNavBar(autoLeading: false),
        banner: header(),
        side: null,
        body: body());
  }

  Widget header() {
    return Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Container(
            height: _screenHeight * (1 - 0.618),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/background.png"),
              fit: BoxFit.cover,
            )),
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 800, // TODO:implement responsive
              padding: EdgeInsets.only(bottom: 20),
              child: Card(
                color: Colors.white,
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: keywords,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        suffix: RaisedButton(
                          onPressed: ()async {
                            await Navigator.pushNamed(context, "/explore",arguments:{"keyword":keywords.text} );
                            setState((){});
                          },
                          color: Colors.brown,
                          splashColor: Colors.white,
                          child:
                              Text("搜索", style: TextStyle(color: Colors.white)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        )),
                  ),
                ),
              ),
            )));
  }

  Widget body() {
    return houseList();
  }

  Widget houseList() {
    return Container(
        // width: (_screenWidth / _screenHeight > 1.2 ? 500 : null),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "本地房源",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
        ),
        tasker.recReady
            ? CabinHouseGridView(children: tasker.recommendations)
            : Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.brown),
                strokeWidth: 2.0,
              )),
      ],
    ));
  }
}

class _Tasker extends Tasker {
  Map<String, dynamic> _data = Map<String, dynamic>();
  Map<String, bool> _status = {"houselist": false};

  _Tasker(VoidCallback onFinished) : super(onFinished: onFinished);
  Future<void> task() async {
    _data["houselist"] = await HouseProvider.instance.getAvailables();
    _status["houselist"] = true;
  }

  List<House> get recommendations {
    if (_status["houselist"] = true)
      return _data["houselist"];
    else
      return null;
  }

  bool get recReady => _status["houselist"];
}
