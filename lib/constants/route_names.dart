import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shuttla/ui/screens/admin/admin_home_screen.dart';
import 'package:shuttla/ui/screens/driver/driver_home_screen.dart';
import 'package:shuttla/ui/screens/onboarding/login_screen.dart';
import 'package:shuttla/ui/screens/passenger/passenger_home_screen.dart';
import 'package:shuttla/ui/screens/onboarding/select_user_screen.dart';
import 'package:shuttla/ui/screens/splash_screen.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/services/session_manager.dart';

class RouteNames {
  ///Route names used through out the app will be specified as static constants here in this format
  /// static const String splashScreen = '/splashScreen';

  static const String splashScreen = 'splashScreen';
  static const String loginScreen = 'loginScreen';
  static const String userSelectScreen = 'userSelectScreen';
  static const String passengerHomeScreen = 'passengerHomeScreen';
  static const String driverHomeScreen = 'driverHomeScreen';
  static const String adminHomeScreen = 'adminHomeScreen';


  static Map<String, Widget Function(BuildContext)> routes = {
    ///Named routes to be added here in this format
    ///RouteNames.splashScreen: (context) => SplashScreen(),
    splashScreen: (context) => SplashScreen(),
    loginScreen: (context) => LoginScreen(),
    userSelectScreen: (context) => UserSelectScreen(),
    passengerHomeScreen: (context) => PassengerHomeScreen(),
    driverHomeScreen: (context) => DriverHomeScreen(),
    adminHomeScreen: (context) => AdminHomeScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Add your screen here as well as the transition you want
      case splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case userSelectScreen:
        return MaterialPageRoute(builder: (context) => UserSelectScreen());
      case passengerHomeScreen:
        return MaterialPageRoute(builder: (context) => PassengerHomeScreen());
      case driverHomeScreen:
        return MaterialPageRoute(builder: (context) => DriverHomeScreen());
      case adminHomeScreen:
        return MaterialPageRoute(builder: (context) => AdminHomeScreen());

    //Default Route is error route
      default:
        return CupertinoPageRoute(
            builder: (context) => errorView(settings.name),
        );
    }
  }

  static Widget errorView(String? name) {
    return Scaffold(body: Center(child: Text('404 $name View not found')));
  }


  static void routeUserRole(BuildContext context, [AppUser? u]) async{
    AppUser? user = u ?? await SessionManager.getUser();

    if(user == null) {
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.loginScreen, (route) => false);
      return;
    }

    switch(user.userData.userTypeEnum){
      case UserType.DRIVER:
        Navigator.pushNamedAndRemoveUntil(context, driverHomeScreen, (route)=> false);
        break;
      case UserType.ADMIN:
        Navigator.pushNamedAndRemoveUntil(context, adminHomeScreen, (route)=> false);
        break;
      case UserType.PASSENGER:
        Navigator.pushNamedAndRemoveUntil(context, passengerHomeScreen, (route)=> false);
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> errorView("Unknown")));
    }
  }
}
