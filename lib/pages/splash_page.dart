import 'package:cabin/base/provider.dart';
import 'package:cabin/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<int> duringSplash() async {
  Map param = Map();
  int userType = 0;
  try {
    param["id"] = await LocalData.obtainValue("id");
    param["password"] = await LocalData.obtainValue("password");
    //TODO: LOGIN
    //TODO: OBTAIN RETURN PACKAGE
    //TODO: OBTAIN userType;
  } catch (erorr) {
    return 0;
  }
  return userType;
}

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
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
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
    int value = await duringSplash();
    await Future.delayed(Duration(milliseconds: 2000));
    Navigator.of(context).pushNamed(widget.outputAndHome[value]);
  }
}
