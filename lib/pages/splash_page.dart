
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Future<int> duringSplash() async {
//   Map param = Map();
//   int userType = 0;
//   try {
//     // param["id"] = await LocalData.obtainValue("id");
//     // param["password"] = await LocalData.obtainValue("password");
//     //TODO: LOGIN
//     //TODO: OBTAIN RETURN PACKAGE
//     //TODO: OBTAIN userType;
//   } catch (erorr) {
//     return 0;
//   }
//   return userType;
// }

class AnimatedSplash extends StatefulWidget {
  // Future<int> customFunction;

  final Map<dynamic, String> outputAndHome = {
    0: '/home',
    /* TODO: input 4 different destination */
  };

  AnimatedSplash() {}

  @override
  _AnimatedSplashState createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash>
   {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    task();
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: FadeTransition(
                opacity: AlwaysStoppedAnimation<double>(1.0),
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.brown),
                  strokeWidth: 2.0,
                )))));
  }

  Future task() async {
    // int value = await duringSplash();
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pushReplacementNamed(context,widget.outputAndHome[0]);
  }
}
