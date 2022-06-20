import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shuttla/constants/route_names.dart';
import 'package:shuttla/constants/user_type_enum.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/services/auth_service.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/ui/screens/passenger/passenger_home_screen.dart';
import 'package:shuttla/ui/size_config/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      SizeConfig().init(context);
      routeUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD3FFFF),
      body: Center(
        child: SizedBox(
          height: 200,
        child: Image.asset("images/logo_gif.gif"),
        ),
      )
    );
  }

  void routeUser() async{
    SessionManager.init();
    AppUser? user = await SessionManager.getUser();
    print(user?.toMap());
    if(user != null) {
      switch(user.userData.userTypeEnum){
        case UserType.DRIVER:
          Navigator.pushNamedAndRemoveUntil(context, RouteNames.driverHomeScreen, (route)=> false);
          break;
        case UserType.ADMIN:
        case UserType.PASSENGER:
        default:
          Navigator.pushNamedAndRemoveUntil(context, RouteNames.passengerHomeScreen, (route)=> false);
      }
    }
    else Navigator.pushNamedAndRemoveUntil(context, RouteNames.loginScreen, (route)=> false);
  }
}
