import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:cabin/pages/explore_page.dart';
import 'package:cabin/pages/home_page.dart';
import 'package:cabin/pages/house_page.dart';
import 'package:cabin/pages/personal_Center_page.dart';
import 'package:cabin/pages/personal_info_edit.dart';
import 'package:cabin/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:cabin/pages/login_page.dart';
import 'pages/splash_page.dart';
void main() {
  runApp(Cabin());
}

class Cabin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cabin!',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Noto Sans"),
      builder: BotToastInit(),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        print('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/': (context) => AnimatedSplash(),
          '/home': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/explore': (context) => ExplorePage(),
          '/PersonalHome': (context) => PersonalCenterPage(),
          '/HouseDetail': (context) => HousePage(),
          '/account/edit': (context) => PersonalInfoEditPage(),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}
