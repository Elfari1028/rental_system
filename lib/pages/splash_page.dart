
import 'package:cabin/base/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AnimatedSplash extends StatefulWidget {
  AnimatedSplash();
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
    await UserProvider.instance.tryGetMyInfo();
    Navigator.pushReplacementNamed(context,'/home');
  }
}
