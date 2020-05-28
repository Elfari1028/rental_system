import 'package:cabin/pages/explore_page.dart';
import 'package:cabin/pages/home_page.dart';
import 'package:cabin/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/splash_page.dart';

final routes = {
  '/': (context) => AnimatedSplash(),
  '/home': (context) => HomePage(),
  '/login': (context) => LoginPage(),
  '/register': (context) => RegisterPage(),
  '/explore': (context) => ExplorePage(),
};

var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
  return null;
};
