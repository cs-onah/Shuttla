import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttla/ui/screens/login_screen.dart';
import 'package:shuttla/ui/screens/splash_screen.dart';

class RouteNames {
  ///Route names used through out the app will be specified as static constants here in this format
  /// static const String splashScreen = '/splashScreen';

  static const String splashScreen = 'splashScreen';
  static const String loginScreen = 'loginScreen';


  static Map<String, Widget Function(BuildContext)> routes = {
    ///Named routes to be added here in this format
    ///RouteNames.splashScreen: (context) => SplashScreen(),
    splashScreen: (context) => SplashScreen(),
    loginScreen: (context) => LoginScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Add your screen here as well as the transition you want
      case splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      //Default Route is error route
      default:
        return CupertinoPageRoute(
            builder: (context) => errorView(settings.name));
    }
  }

  static Widget errorView(String? name) {
    return Scaffold(body: Center(child: Text('404 $name View not found')));
  }
}
