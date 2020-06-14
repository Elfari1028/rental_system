import 'package:bot_toast/bot_toast.dart';
import 'package:cabin/base/user.dart';
import 'package:cabin/pages/admin/house_list.dart';
import 'package:cabin/pages/admin/order_list.dart';
import 'package:cabin/pages/admin/request_list.dart';
import 'package:cabin/pages/admin/user_list.dart';
import 'package:cabin/pages/maintenance/request_list.dart';
import 'package:cabin/pages/personal_center_page.dart';
import 'package:cabin/pages/rentee/order_list.dart';
import 'package:cabin/pages/rentee/request_list.dart';
import 'package:cabin/pages/support_page.dart';
import 'package:cabin/widget/editor/house_editor.dart';
import 'package:cabin/widget/editor/support_request_editor.dart';
import 'package:cabin/widget/editor/user_editor.dart';
import 'package:flutter/material.dart';
import 'package:cabin/pages/explore_page.dart';
import 'package:cabin/pages/home_page.dart';
import 'package:cabin/pages/house_page.dart';
import 'package:cabin/pages/register_page.dart';
import 'package:cabin/pages/login_page.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(Cabin());
}

class Cabin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '木居——青年租房平台',
      theme: ThemeData(
          // buttonColor: Colors.brown,
          primaryIconTheme: IconThemeData(color:Colors.black),
          iconTheme: IconThemeData(color: Colors.brown),
          buttonTheme: ButtonThemeData(
              padding: EdgeInsets.all(5),
              textTheme: ButtonTextTheme.primary,
              colorScheme: ColorScheme(
                  primary: Colors.brown,
                  primaryVariant: Colors.brown[400],
                  secondary: Colors.blueGrey[800],
                  secondaryVariant: Colors.blueGrey,
                  surface: Colors.white,
                  background: Colors.transparent,
                  error: Colors.red,
                  onPrimary: Colors.black,
                  onSecondary: Colors.white,
                  onSurface: Colors.black,
                  onBackground: Colors.white,
                  onError: Colors.white,
                  brightness: Brightness.light)),
          primarySwatch: Colors.brown,
          visualDensity: VisualDensity.adaptivePlatformDensity,),
      builder: BotToastInit(),
      initialRoute: '/',
      onGenerateRoute: _getRoute,
    );
  }
}

Route<dynamic> _getRoute(RouteSettings settings) {
  Widget widget;
  print(settings.name);
  switch (settings.name) {
    case '/':
      widget = AnimatedSplash();
      break;
    case '/home':
      if(UserProvider.currentUser == null || UserProvider.currentUser.type == UserType.rentee)widget = HomePage();
      else widget = PersonalCenterPage();
      break;
    case '/login':
      widget = LoginPage();
      break;
    case '/register':
      widget = RegisterPage();
      break;
    case '/explore':
      Map arguments = settings.arguments as Map;
      widget = ExplorePage(arguments["keyword"]);
      break;
    case '/center':
      widget = PersonalCenterPage();
      break;
    case '/house/detail':
      Map arguments = settings.arguments as Map;
      widget = HousePage(arguments["house"]);
      break;
    case '/house/edit':
      Map arguments = settings.arguments as Map;
      widget = HouseEditor(arguments["house"]);
      break;
    case '/house/create':
      Map arguments = settings.arguments as Map;
      widget = HouseEditor(arguments["house"]);
      break;
    case '/house/all':
      widget = AdminHouseListPage();
      break;
    case '/account/edit':
      Map arguments = settings.arguments as Map;
      widget = UserEditor(arguments["user"], arguments["isAdmin"]);
      // print("success");
      break;
    case '/account/all':
      widget = AdminUserListPage();
      break;
    case '/order/all':
      widget = AdminOrderListPage();
      break;
    case '/order/mine':
      widget = RenteeOrderListPage();
      break;
    case '/support/all':
      widget = AdminSupportRequestListPage();
      break;
    case '/support/mine':
      widget = RenteeSupportRequestListPage();
      break;
    case '/support/maintenance':
      widget = FixerSupportRequestListPage();
      break;
    case '/support/create':
     Map arguments = settings.arguments as Map;
      widget = SupportRequestEditor(arguments["order"], arguments["init"]);
      break;
    case '/support/conversation':
     Map arguments = settings.arguments as Map;
      widget = SupportConvoPage(arguments["request"]);
      break;
    default:
      return null;
  }
  return _buildRoute(settings, widget);
}

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return new MaterialPageRoute(
    settings: settings,
    builder: (ctx) => builder,
  );
}
