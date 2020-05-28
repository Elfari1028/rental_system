import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Cabin());
}

class Cabin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '木居',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Noto Sans"),
      routes: routes,
      builder: BotToastInit(),
      initialRoute: '/',
    );
  }
}
